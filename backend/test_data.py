from autodo.models import User, Car, OdomSnapshot, Refueling
from autodo.serializers import CarSerializer

User.objects.create_superuser("root", "root@example.com", "root1234")
u = User.objects.filter(username="root")[0]
print(u)

c1_snaps = [
    {"date": "2020-08-02T00:00:00", "mileage": 1000},
    {"date": "2020-08-03T00:00:00", "mileage": 2000},
    {"date": "2020-08-04T00:00:00", "mileage": 3000},
    {"date": "2020-08-05T00:00:00", "mileage": 4000},
    {"date": "2020-08-06T00:00:00", "mileage": 5000},
]
data = {"name": "test1", "snaps": c1_snaps}
c1 = CarSerializer(data=data)
if c1.is_valid():
    c1.save(owner=u)
else:
    print(c1.errors)
c2 = Car(owner=u, name="test2")
c2.save()

snaps = OdomSnapshot.objects.all()

r1 = Refueling(owner=u, odomSnapshot=snaps[0], cost=1000, amount=10)
r1.save()
r2 = Refueling(owner=u, odomSnapshot=snaps[1], cost=1000, amount=20)
r2.save()
r3 = Refueling(owner=u, odomSnapshot=snaps[2], cost=1000, amount=150)
r3.save()
r4 = Refueling(owner=u, odomSnapshot=snaps[3], cost=1000, amount=120)
r4.save()
r5 = Refueling(owner=u, odomSnapshot=snaps[4], cost=1000, amount=10)
r5.save()
