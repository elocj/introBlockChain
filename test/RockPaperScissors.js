const RPS = artifacts.require("./RockPaperScissors.sol");

contract("RPS", accounts => {
  it("should work", async () => {
    const rPS = await RPS.deployed();

    // Set myString to "Hey there!"
    await rPS.setPlayer(accounts[0], 1000);

    // Get myString from public variable getter
    const storedString = await rPS.player.call();
    console.log(storedString)
    assert.equal(storedString, accounts[0], "The string was not stored");
  });
});
