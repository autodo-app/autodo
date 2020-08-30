from autodo.models import User, Car, OdomSnapshot, Refueling

User.objects.create_superuser('root', 'root@example.com', 'root1234')
u = User.objects.filter(username='root')[0]

c1 = Car(owner=u, name='test1')
c1.save()
c2 = Car(owner=u, name='test2')
c2.save()

o1 = OdomSnapshot(owner=u, car=c1, date='2020-08-02T00:00:00', mileage=1000)
o1.save()
o2 = OdomSnapshot(owner=u, car=c1, date='2020-08-03T00:00:00', mileage=2000)
o2.save()
o3 = OdomSnapshot(owner=u, car=c1, date='2020-08-04T00:00:00', mileage=3000)
o3.save()
o4 = OdomSnapshot(owner=u, car=c1, date='2020-08-05T00:00:00', mileage=4000)
o4.save()
o5 = OdomSnapshot(owner=u, car=c1, date='2020-08-06T00:00:00', mileage=5000)
o5.save()

r1 = Refueling(owner=u, odomSnapshot=o1, cost=1000, amount=10)
r1.save()
r2 = Refueling(owner=u, odomSnapshot=o2, cost=1000, amount=20)
r2.save()
r3 = Refueling(owner=u, odomSnapshot=o3, cost=1000, amount=150)
r3.save()
r4 = Refueling(owner=u, odomSnapshot=o4, cost=1000, amount=120)
r4.save()
r5 = Refueling(owner=u, odomSnapshot=o5, cost=1000, amount=10)
r5.save()
