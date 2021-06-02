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

        #cycles through elevatorsList and finds the bestFloorGap and assigns bestElevator
        #Also ensures the best elevator is idle
        (0...elevatorsList.size).each do |i|
            currentFloorGap = (elevatorsList[i].currentFloor - _requestedFloor).abs
            elevatorMovingStatus = elevatorsList[i].status
            if(elevatorMovingStatus != 'idle')
                currentFloorGap = 10000
            end
            if(currentFloorGap < bestFloorGap)
                bestFloorGap = currentFloorGap
                bestElevator = elevatorsList[i]
            end
        end
        #Moves elevator up or down until it matches _requestedFloor, then opens the door
        while(_requestedFloor < bestElevator.currentFloor)
            bestElevator.currentFloor = bestElevator.currentFloor - 1
            bestElevator.direction = 'down'
            bestElevator.status = 'moving'
            print("Elevator is on floor #{bestElevator.currentFloor}\n")
        end
        while(_requestedFloor > bestElevator.currentFloor)
            bestElevator.currentFloor = bestElevator.currentFloor + 1
            bestElevator.direction = 'up'
            bestElevator.status = 'moving'
            print("Elevator is on floor #{bestElevator.currentFloor}\n")
        end
        while(_requestedFloor == bestElevator.currentFloor)
            bestElevator.direction = nil
            bestElevator.door.status = 'open'
            bestElevator.status = 'idle'
            print("*DING* The elevator doors are #{bestElevator.door.status}\n")
            print("Your elevator has arrived, please enter now.\n")
            break
        end
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
            print("Your elevator has arrived, please exit now.\n")
            break
        end
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

testColumn = Column.new(1, 10, 2)
testColumn.elevatorsList[0].currentFloor = 2
testColumn.elevatorsList[1].currentFloor = 6
elevatorToUse = testColumn.requestElevator(3, 'up')
elevatorToUse.requestFloor(7)
print("Elevator A Scenario 1 Final Position ", testColumn.elevatorsList[0].currentFloor, "\n")
print("Elevator B Scenario 1 Final Position ", testColumn.elevatorsList[1].currentFloor, "\n")
