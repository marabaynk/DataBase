import random

with open("DealerName.txt") as file:
    DealerNameArr = [row.strip() for row in file]

with open("CarModel.txt") as file:
    CarModelArr = [row.strip() for row in file]

with open("cities.txt") as file:
    CityArr = [row.strip() for row in file]  


f = open("Factory.csv", "w")
f.write("FactoryId,City,Amount\n")

for i in range(1, 101):
    CityName = random.choice(CityArr)
    string = "{0},{1},{2}\n".format(i, CityName, random.randint(1, 300))
    f.write(string)
f.close()


f = open("Car.csv", "w")
f.write("CarId,CarModel,DateOfIssue,HorsePower,Transmission\n")

for i in range(1, 101):
    CarModel = random.choice(CarModelArr)
    string = "{0},{1},{2}.{3}.{4},{5},{6}\n".format(i, CarModel, random.randint(1, 28), random.randint(1, 12), random.randint(2010, 2019), random.randint(100, 700), random.randint(0,1))
    f.write(string)
f.close()


f = open("Dealer.csv", "w")
f.write("DealerId,City,DealerName,CarAmount\n")

for i in range(1, 101):
    DealerName = random.choice(DealerNameArr)
    CityName = random.choice(CityArr)
    string = "{0},{1},{2},{3}\n".format(i, CityName, DealerName, random.randint(1,100))
    f.write(string)
f.close()


f = open("MercedesBenz.csv", "w")
f.write("MercedesBenzId,CarId,DealerId,FactoryId,DeliveryDate\n")

for i in range(1, 101):
    string = "{0},{1},{2},{3},{4}.{5}.{6}\n".format(i, random.randint(1, 100), random.randint(1, 100), random.randint(1, 100), random.randint(1, 28), random.randint(1, 12), random.randint(2010, 2019))
    f.write(string)
f.close()


