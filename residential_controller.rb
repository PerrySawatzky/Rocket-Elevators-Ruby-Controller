#Create your column and the rest is taken care of.
class Column
    attr_accessor :ID, :status, :elevatorsList, :callButtonsList, :bestElevator, :bestFloorGap, :currentFloor
    def initialize(_id, _amountOfFloors, _amountOfElevators)
        @ID = _id
        @status = 'built'
        @elevatorsList = []
        @callButtonsList = []
        #creates Elevators
        (0..._amountOfElevators).each do |i|
            current_elevator = Elevator.new(i, _amountOfFloors)
            elevatorsList.push(current_elevator)
        end
        #creates CallButtons
        (0..._amountOfFloors).each do |i|
            if(i != _amountOfFloors - 1)
                newButtonUp = CallButton.new(i, i+1, 'up', 'off')
                callButtonsList.push(newButtonUp)
            end
            if(i != 0)
                newButtonDown = CallButton.new(i, i+1, 'down', 'off')
                callButtonsList.push(newButtonDown)
            end
        end
    end
    #Runs through the columns elevatorsList and finds the smallest floor gap
    def requestElevator(_requestedFloor, _direction)
        bestElevator = nil
        bestFloorGap = 10000
        #cycles through elevatorsList and finds the best elevator
        (0...elevatorsList.size).each do |i|
            currentFloorGap = (elevatorsList[i].currentFloor - _requestedFloor).abs
            elevatorMovingStatus = elevatorsList[i].status
            elevatorDirection = elevatorsList[i].direction
            elevatorCurrentFloor = elevatorsList[i].currentFloor
            #Elevator moving in the opposite direction, dont want it.
            if(elevatorMovingStatus != 'idle' && _direction != elevatorDirection)
                currentFloorGap = 10000
            end
            #The elevator is above the user. It is going up and so is the user.
            if(_direction == elevatorDirection && elevatorDirection == "down" && _requestedFloor < elevatorCurrentFloor)
                bestFloorGap = currentFloorGap
                bestElevator = elevatorsList[i]
            end
            #The elevator is below the user. It is coming down and so is the user.
            if(_direction == elevatorDirection && elevatorDirection == "up" && _requestedFloor > elevatorCurrentFloor)
                bestFloorGap = currentFloorGap
                bestElevator = elevatorsList[i]
            end
            #The elevator is idle and close to user.
            if(currentFloorGap < bestFloorGap && elevatorMovingStatus == 'idle')
                bestFloorGap = currentFloorGap
                bestElevator = elevatorsList[i]
            end
        end
        bestElevator.floorRequestList.push(_requestedFloor)
        bestElevator.moveElevator()
        return bestElevator #So we can call on the function and give us the same elevator when using requestFloor when testing
    end
end
#Automatically created when Column is created
class Elevator
    attr_accessor :ID, :status, :direction, :currentFloor, :door, :floorRequestButtonsList, :floorRequestList
    def initialize(_id, _amountOfFloors)
        @ID = _id
        @status = 'idle'
        @direction = nil
        @currentFloor = 1
        @door = Door.new(_id)
        @floorRequestButtonsList = []
        @floorRequestList = []
        #Creates 1 FloorRequestButtons for each floor
        (0..._amountOfFloors).each do |i|
            newFloorRequestButton = FloorRequestButton.new(i-1, i)
            floorRequestButtonsList.push(newFloorRequestButton)
        end
    end
    # Same idea as the requestElevator method, moves up or down one floor at a time until requestedFloor is equal to currentFloor
    def requestFloor(_requestedFloor)
        while self.currentFloor > _requestedFloor
            self.currentFloor = self.currentFloor - 1
            door.status = 'closed'
            status = 'moving'
            print("Elevator is on floor #{self.currentFloor}\n")
        end
        while self.currentFloor < _requestedFloor
            self.currentFloor = self.currentFloor + 1
            door.status = 'closed'
            status = 'moving'
            print("Elevator is on floor #{currentFloor}\n")
        end
        while self.currentFloor == _requestedFloor
            door.status = 'open'
            status = 'idle'
            print("*DING* Your elevator has arrived, please exit now.\n")
            break
        end
    end
    def moveElevator()
        destination = self.floorRequestList[0]
        while self.floorRequestList.size != 0
            while destination > self.currentFloor
                self.currentFloor = self.currentFloor + 1
                self.direction = "up"
                self.status = "moving"
                print("Elevator is on floor #{self.currentFloor}\n")
            end
            while destination < self.currentFloor
                self.currentFloor = self.currentFloor - 1
                self.direction = "down"
                self.status = "moving"
                print("Elevator is on floor #{self.currentFloor}\n")
            end
            while destination == self.currentFloor
                self.direction = nil
                self.door.status = 'open'
                print("*DING* The elevator doors are #{self.door.status}\n")
                print("Your elevator has arrived, please enter now.\n")
                break
            end
            self.floorRequestList.shift()
        end
        self.status = "idle"
    end
end


#Automatically created when Column is created
class CallButton
    attr_accessor :ID, :floor, :direction, :light
    def initialize(_id, _floor, _direction, _light)
        @ID = _id
        @floor = _floor
        @direction = _direction
        @light = _light
    end
end

#Automatically created when Elevator is created
class FloorRequestButton
    attr_accessor :ID, :status, :floor
    def initialize(_id, _floor)
        @ID = _id
        @status = 'off'
        @floor = _floor
    end
end

#Also automatically created when Elevator is created
class Door
    attr_accessor :ID, :status
    def initialize(_id)
        @ID = _id
        @status = 'closed'
    end
end

scenario1 = Column.new(1, 10, 2)
scenario1.elevatorsList[0].currentFloor = 2
scenario1.elevatorsList[1].currentFloor = 6
elevatorToUse = scenario1.requestElevator(3, 'up')
elevatorToUse.requestFloor(7)
print("Elevator A Scenario 1 Final Position ", scenario1.elevatorsList[0].currentFloor, "\n")
print("Elevator B Scenario 1 Final Position ", scenario1.elevatorsList[1].currentFloor, "\n")

# scenario2 = Column.new(1, 10, 2)
# scenario2.elevatorsList[0].currentFloor = 10
# scenario2.elevatorsList[1].currentFloor = 3
# elevatorToUse = scenario2.requestElevator(1, 'up')
# elevatorToUse.requestFloor(6)
# elevatorToUse1 = scenario2.requestElevator(3, "up")
# elevatorToUse1.requestFloor(5)
# elevatorToUse2 = scenario2.requestElevator(9, "down")
# elevatorToUse2.requestFloor(2)
# print("Elevator A Scenario 2 Final Position ", scenario2.elevatorsList[0].currentFloor, "\n")
# print("Elevator B Scenario 2 Final Position ", scenario2.elevatorsList[1].currentFloor, "\n")

# scenario3 = Column.new(1, 10, 2)
# scenario3.elevatorsList[0].currentFloor = 10
# scenario3.elevatorsList[1].currentFloor = 3
# scenario3.elevatorsList[1].status = "moving"
# elevatorToUse = scenario3.requestElevator(3, "down")
# elevatorToUse.requestFloor(2)
# scenario3.elevatorsList[1].currentFloor = 6
# scenario3.elevatorsList[1].status = "idle"
# elevatorToUse1 = scenario3.requestElevator(10, "down")
# elevatorToUse1.requestFloor(3)
# print("Elevator A Scenario 3 Final Position ", scenario3.elevatorsList[0].currentFloor, "\n")
# print("Elevator B Scenario 3 Final Position ", scenario3.elevatorsList[1].currentFloor, "\n")