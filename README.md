# Rocket-Elevators-Ruby-Controller
> A first week project for Rocket Elevators. Subsidiary of Codeboxx Technologies
## Table of Contents
* [General](#general)
* [Technologies](#technologies)
* [Setup](#setup)
* [Code Examples](#Code-Examples)

## General
This project features a simulated elevator sender and retriever algorithm that operates in the command terminal.
It has two methods, requestElevator and requestFloor.

## Technologies
Project is created with:
* JavaScript
* Node.js verson 14.16.1
* Ruby version 2.6.3p62

## Setup
To run this project, clone it through your Command Line Interface locally by entering:
```
gh repo clone PerrySawatzky/Rocket-Elevators-Ruby-Controller
```
Ruby is required, [download here](https://www.ruby-lang.org/en/downloads/)

## Code Examples
This repo includes 3 test scenarios at the bottom of the file, starting at line 159.

However only three lines are absolutely critical. The first creates the elevator column, and the two subsequent create the request methods:
```
scenario1 = Column.new(1, 10, 2)
elevatorToUse = scenario1.requestElevator(3, 'up')
elevatorToUse.requestFloor(7)
```
The three parameters for Column are id, number of floors, and number of elevators respectfully.

We assign a variable, in this case 'elevatorToUse' to the requestElevator method in order for the same elevator to be assigned when completing the subsequent requestFloor method. 

The first parameter in the requestElevator method is the floor number, the second is the direction the user is requesting.

The only parameter in the requestFloor method is the floor the user requested.

In order to set up a complex scenario, you can set certain properties of the elevator before hand, as well as run multiple requests at the same time. This is what that would look like:
```
scenario2 = Column.new(1, 10, 2)
scenario2.elevatorsList[0].currentFloor = 10
scenario2.elevatorsList[1].currentFloor = 3
elevatorToUse = scenario2.requestElevator(1, 'up')
elevatorToUse.requestFloor(6)
elevatorToUse1 = scenario2.requestElevator(3, "up")
elevatorToUse1.requestFloor(5)
elevatorToUse2 = scenario2.requestElevator(9, "down")
elevatorToUse2.requestFloor(2)
print("Elevator A Scenario 2 Final Position ", scenario2.elevatorsList[0].currentFloor, "\n")
print("Elevator B Scenario 2 Final Position ", scenario2.elevatorsList[1].currentFloor, "\n")
```
To run the algorithms in the command line terminal, simply type:
```
ruby residential_controller.rb
```
and hit enter.