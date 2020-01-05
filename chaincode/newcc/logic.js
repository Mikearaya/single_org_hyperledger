const { Contract } = require('fabric-contract-api');

class testContract extends Contract {
  async addMarks(ctx, studentId, subject1, subject2, subject3) {
    let marks = {
      subj1: subject1,
      subj2: subject2,
      subj3: subject3
    };

    await ctx.stub.putState(studentId, Buffer.from(JSON.stringify(marks)));

    console.log('Student mark added to the ledger');
  }

  async deleteMarks(ctx, studentId) {
    await ctx.stub.deleteState(studentId);
    console.log('Student deleted successfuly');
  }

  async queryMarks(ctx, studentId) {
    let marksAsBytes = await ctx.stub.getState(studentId);

    if (!marksAsBytes || marksAsBytes.toString().length <= 0) {
      throw new Error('Student with id not found');
    }

    let marks = JSON.parse(marksAsBytes.toString());
  }
}
