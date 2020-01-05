/*
 * SPDX-License-Identifier: Apache-2.0
 */

"use strict";

const { Contract } = require("fabric-contract-api");

class TestChainCode extends Contract {
    async initLedger(ctx) {
        console.info("============= START : Initialize Ledger ===========");

        const contacts = [
            {
                FullName: "Mikael Araya",
                Email: "Mikaelaraya12@gmail.com",
                PhoneNumber: "0912883377"
            },
            {
                FullName: "Dagim Alemayehu",
                Email: "Alex@gmail.com",
                PhoneNumber: "43534534"
            },
            {
                FullName: "Haile Mikael",
                Email: "hailemikael@gmail.com",
                PhoneNumber: "54654645"
            },
            {
                FullName: "Dagim Alemayehu",
                Email: "sfsfdsfsdfsdfex@gmail.com",
                PhoneNumber: "4353535"
            }
        ];
        for (let i = 0; i < contacts.length; i++) {
            contacts[i].docType = "CONTACT";
            await ctx.stub.putState(
                "CONTACT-" + i,
                Buffer.from(JSON.stringify(contacts[i]))
            );
            console.info("Added <--> ", contacts[i]);
        }
        console.info("============= END : Initialize Ledger ===========");
    }

    async queryContact(ctx, contactNumber) {
        const contactAsByte = await ctx.stub.getState(contactNumber); // get the car from chaincode state
        if (!contactAsByte || contactAsByte.length === 0) {
            throw new Error(`${contactNumber} does not exist`);
        }
        console.log(contactAsByte.toString());
        return contactAsByte.toString();
    }

    async createCar(ctx, contactNumber, fullName, email, phoneNumber) {
        console.info("============= START : Create Car ===========");

        const contact = {
            fullName,
            docType: "CONTACT",
            email,
            phoneNumber
        };

        await ctx.stub.putState(
            "CONTACT-" + contactNumber,
            Buffer.from(JSON.stringify(contact))
        );
        console.info("============= END : Create Contact ===========");
    }

    async queryAllCars(ctx) {
        const startKey = "CONTACT-0";
        const endKey = "CONTACT-999";
        console.info("============= Inside query all cars function===========");
        const iterator = await ctx.stub.getStateByRange(startKey, endKey);
        console.info("============= Extracted Contacts ===========");
        console.log(iterator);

        const allResults = [];
        while (true) {
            const res = await iterator.next();

            if (res.value && res.value.value.toString()) {
                console.log(res.value.value.toString("utf8"));

                const Key = res.value.key;
                let Record;
                try {
                    Record = JSON.parse(res.value.value.toString("utf8"));
                } catch (err) {
                    console.log(err);
                    Record = res.value.value.toString("utf8");
                }
                allResults.push({ Key, Record });
            }
            if (res.done) {
                console.log("end of data");
                await iterator.close();
                console.info(allResults);
                return JSON.stringify(allResults);
            }
        }
    }

    async deleteContact(ctx, contactNumber) {
        const result = await ctx.stub.deleteState(contactNumber);
        console.log(result);
    }
}

module.exports = TestChainCode;
