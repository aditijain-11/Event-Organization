//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract EventContract{
    struct Event{
        address Organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;

    }
    mapping(uint => Event) public events;
    mapping(address => mapping(uint => uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name, uint date, uint price, uint ticketCount) external{
        // checking if events are scheduled for dates after the event is created
        require(date>block.timestamp, "you can organize event for future dates");
        // checking if tickets are left
        require(ticketCount>0,"you can organize event only if you create more than 0 tickets");

        events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextId++;
    }
    function buyTickets(uint id, uint quantity) external payable{
        require(events[id].date != 0,"Event doesn't exist");
        require(events[id].date>block.timestamp,"Events has already occured");
        Event storage _event = events[id];
        require(msg.value == (_event.price*quantity),"Ether is not enough");
        require(_event.ticketRemain>=quantity,"Not Enough tickets");
        _event.ticketRemain -= quantity;

        // complex mapping explanation
        tickets[msg.sender][id] += quantity;

    } 

    function transfer(uint id, uint quantity, address to) external{
        require(events[id].date != 0,"Event doesn't exist");
        require(events[id].date>block.timestamp,"Events has already occured");
        require(tickets[msg.sender][id]>=quantity, "you do not have enough tickets");
        tickets[msg.sender][id] -= quantity;
        tickets[to][id] += quantity;
    }

}