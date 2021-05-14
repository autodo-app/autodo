from collections import defaultdict
from functools import reduce
from itertools import groupby
from statistics import mean
from datetime import timezone

from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods

from autodo.models import Car, Refueling, OdomSnapshot, Todo

ALPHA = 0.3
EMA_CUTOFF = 3  # EMA works best with some averages in the history


def single_efficiency(i: Refueling, j: Refueling) -> float:
    dist_diff = j.odomSnapshot.mileage - i.odomSnapshot.mileage
    return dist_diff / j.amount


def ema(data: list) -> list:
    ema = []
    for i, v in enumerate(data):
        if i == 0:
            ema.append(v)
        elif i < EMA_CUTOFF:
            cur_aves = ema.copy()
            cur_aves.append(v)
            ema.append(mean(cur_aves))
        else:
            prev = ema[-1]
            ema.append(ALPHA * v + (1 - ALPHA) * prev)
    return ema


@csrf_exempt
@require_http_methods(["GET"])
def fuelEfficiencyStats(request):
    data = defaultdict(dict)
    cars = Car.objects.filter(owner=request.user.id)
    for c in cars:
        refuelings = Refueling.objects.filter(odomSnapshot__car=c.id).order_by(
            "odomSnapshot__mileage"
        )
        mpgs = [single_efficiency(s, t) for s, t in zip(refuelings, refuelings[1:])]
        emas = ema(mpgs)
        data[c.id] = {"name": c.name, "color": c.color}
        data[c.id]["data"] = [
            {
                "time": r.odomSnapshot.date.replace(tzinfo=timezone.utc).timestamp()
                * 1000,
                "raw": mpgs[i],
                "filtered": emas[i],
            }
            for i, r in enumerate(refuelings[1:])
        ]
    return JsonResponse(data)


@csrf_exempt
@require_http_methods(["GET"])
def fuelUsageByCarStats(request):
    cars = Car.objects.filter(owner=request.user.id)
    gas_used = {}
    for c in cars:
        refuelings = Refueling.objects.filter(odomSnapshot__car=c.id)
        if len(refuelings) == 0:
            amount = 0
        else:
            amount = reduce(
                lambda i, j: i + j,
                map(
                    lambda x: x.amount,
                    Refueling.objects.filter(odomSnapshot__car=c.id),
                ),
            )
        gas_used[c.id] = {"name": c.name, "amount": amount, "color": c.color}
    return JsonResponse(gas_used)


def single_distance_rate(i, j):
    dayDiff = (j.date - i.date).days
    # if both snapshots are in the same day then multiply the rate by two
    dayDiff = dayDiff if (dayDiff >= 1) else 0.5
    return (j.mileage - i.mileage) / dayDiff


@csrf_exempt
@require_http_methods(["GET"])
def drivingRateStats(request):
    data = {}
    cars = Car.objects.filter(owner=request.user.id)
    for c in cars:
        odomSnaps = OdomSnapshot.objects.filter(car=c.id).order_by("date")

        rates = [single_distance_rate(s, t) for s, t in zip(odomSnaps, odomSnaps[1:])]
        data[c.id] = {"name": c.name, "color": c.color}
        data[c.id]["data"] = [
            {
                "time": s.date.replace(tzinfo=timezone.utc).timestamp() * 1000,
                "raw": rates[i],
            }
            for i, s in enumerate(odomSnaps[1:])
        ]
        data[c.id]["data"] = [
            rate for rate in data[c.id]["data"] if rate["raw"] > 0
        ]  # eliminate bad data

    return JsonResponse(data)


@csrf_exempt
@require_http_methods(["GET"])
def fuelUsageByMonthStats(request):
    data = {}
    cars = Car.objects.filter(owner=request.user.id)
    for c in cars:
        refuelings = Refueling.objects.filter(odomSnapshot__car=c.id).order_by(
            "odomSnapshot__date"
        )
        mapped = list(
            map(
                lambda r: {
                    # Use replace to set the day to a value in the middle of the month so that the charts library can round it properly
                    "date": r.odomSnapshot.date.replace(day=3).timestamp() * 1000,
                    "amount": r.amount,
                },
                refuelings,
            )
        )
        groups = groupby(mapped, key=lambda e: e["date"])
        amounts = []
        for k, v in groups:
            total = 0
            for e in v:
                total += e["amount"]
            amounts.append({"date": k, "amount": total})
        data[c.id] = {"name": c.name, "amounts": amounts, "color": c.color}

    return JsonResponse(data)


@csrf_exempt
@require_http_methods(["GET"])
def completedTodosStats(request):
    return JsonResponse(
        {
            "count": Todo.objects.filter(owner=request.user.id)
            .filter(complete=True)
            .count()
        }
    )


@csrf_exempt
@require_http_methods(["GET"])
def refuelingsLoggedStats(request):
    return JsonResponse(
        {"count": Refueling.objects.filter(owner=request.user.id).count()}
    )
