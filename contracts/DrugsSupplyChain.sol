// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract DrugsSupplyChain {
    uint constant DAY_IN_SECONDS = 86400;
    uint constant YEAR_IN_SECONDS = 31536000;
    uint constant LEAP_YEAR_IN_SECONDS = 31622400;

    uint constant HOUR_IN_SECONDS = 3600;
    uint constant MINUTE_IN_SECONDS = 60;

    uint16 constant ORIGIN_YEAR = 1970;

    struct Drug {
        bool isExpired;
        uint256 id;
        string name;
        string manufacturer;
        uint256 expiryDate;
        uint256 quantity;
    }
    struct Transaction {
        address fromAddress;
        address toAddress;
        Drug drug;
        uint256 timestamp;
    }

    struct Date {
        uint16 year;
        uint8 month;
        uint8 day;
    }

    Transaction[] private transactions;
    mapping(uint256 => Drug) public drugs;
    uint256[] expiredDrugIds;
    uint256 expiredItemCount = 0;
    uint256 drugCount;

    function addTransaction(
        address _fromAddress,
        address _toAddress,
        uint256 _id
    ) public {
        transactions.push(
            Transaction({
                fromAddress: _fromAddress,
                toAddress: _toAddress,
                drug: drugs[_id],
                timestamp: block.timestamp
            })
        );
    }

    function addDrug(
        uint256 _id,
        string memory _name,
        string memory _manufacturer,
        uint256 _expiryDate,
        uint256 _quantity
    ) public {
        drugCount++;
        drugs[_id] = Drug({
            isExpired: false,
            id: _id,
            name: _name,
            quantity: _quantity,
            manufacturer: _manufacturer,
            expiryDate: _expiryDate
        });
    }

    function checkExpiry() public {
        for (uint256 i = 0; i < drugCount; i++) {
            uint256 currentTime = block.timestamp;
            if ((currentTime - drugs[i].expiryDate) > 0) {
                drugs[i].isExpired = true;
                expiredDrugIds.push(drugs[i].id);
                expiredItemCount++;
            }
        }
    }

    function getExpiredItems() public view returns (uint256[] memory, uint256) {
        return (expiredDrugIds, expiredItemCount);
    }

    function getDrugs(uint256 _id) public view returns (Drug memory) {
        return drugs[_id];
    }

    function getTransactions() public view returns (Transaction[] memory) {
        return transactions;
    }

    function getDrugCount() public view returns (uint256) {
        return drugCount;
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////// //Extra Stuff/////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    function toTimestamp(
        uint16 year,
        uint8 month,
        uint8 day,
        uint8 hour,
        uint8 minute,
        uint8 second
    ) public pure returns (uint timestamp) {
        uint16 i;

        // Year
        for (i = ORIGIN_YEAR; i < year; i++) {
            if (isLeapYear(i)) {
                timestamp += LEAP_YEAR_IN_SECONDS;
            } else {
                timestamp += YEAR_IN_SECONDS;
            }
        }

        // Month
        uint8[12] memory monthDayCounts;
        monthDayCounts[0] = 31;
        if (isLeapYear(year)) {
            monthDayCounts[1] = 29;
        } else {
            monthDayCounts[1] = 28;
        }
        monthDayCounts[2] = 31;
        monthDayCounts[3] = 30;
        monthDayCounts[4] = 31;
        monthDayCounts[5] = 30;
        monthDayCounts[6] = 31;
        monthDayCounts[7] = 31;
        monthDayCounts[8] = 30;
        monthDayCounts[9] = 31;
        monthDayCounts[10] = 30;
        monthDayCounts[11] = 31;

        for (i = 1; i < month; i++) {
            timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
        }

        // Day
        timestamp += DAY_IN_SECONDS * (day - 1);

        // Hour
        timestamp += HOUR_IN_SECONDS * (hour);

        // Minute
        timestamp += MINUTE_IN_SECONDS * (minute);

        // Second
        timestamp += second;

        return timestamp;
    }

    function isLeapYear(uint16 year) public pure returns (bool) {
        if (year % 4 != 0) {
            return false;
        }
        if (year % 100 != 0) {
            return true;
        }
        if (year % 400 != 0) {
            return false;
        }
        return true;
    }
}
