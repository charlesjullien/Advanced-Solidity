## Smart contract security is essential in blockchain development as we technically cannot modify or fix a classic contract once it's deployed.

The Vulnerable contracts contracts in this repo are from https://github.com/clesaege/HackSmartContract/blob/master/contracts/SolidityHackingWorkshopV8.sol which is an exercise to spot the vulnerabilities and acquire good security practices.

Many types of attacks exists such as :

- **DoS** ("Denial of Service"): A malicious contract can block the usage of a DoS vulnerable contract by two types of means : gas limit or unexpected error. 
some examples :

    *Unexpected* : 
      A bidding contract can block, if when a higher bid is placed, there is a direct refund of the previous leader, and that this refund cannot be done       because it is blocked by the attacker (on a contract without fallback and with an attacking address unable to receive funds).

    *Gas limit* : 
      A voting contract where whitelisted users can add proposals to vote for them later on... When the votes are tallied, the contract iterates on all         proposals... If an attacker wants to perfor a DoS attack, he can just send a lot of proposals earlier to setup a huge proposal array on the SC and       during iteration, a gas limit will be reached and the SC won't be able to tally votes.

- **Reentrancy** : the attacker creates his own contract and calls a vulnerable function of the attacked contract from here; once the vulnerable function is beeing executed, a fallback function from the attacker is being triggered to call again the vulnerable function without waiting for the current function execution to end and a loop is installed. The attacker can, by doing so, manipulate the datas inside the smart contract to his advantage.
A good practice is, for instance to setup flags like booleans at the begining and end of the function, add more 'requires' to check current datas, use temporary variables to store datas or use ReeantrancyGuards from Openzeppelin.

- **Oracle Manipulation** : some Oracles (voluntarly or not) can have a false datafeed if they are malicious or deprecated. As an example, with flash loans, Oracles can be manipulated by returning an incorrect value modified by the flash loan... making the change rate of an asset much lower or higher for the malicious contract as the attacked contract depends on a manipulated (trough flash loans here) Oracle.
A good practice for such contracts is to multiply the off chains sources of information and not depend on only one oracle.

- **Front running** : before getting executed by validators, transactions are in the mempool (check https://txstreet.com/v/eth to have a visual insight of what is a mempool). While those tx are pending for approval, network observers can see the content of those txs and init a tx to be executed before the pending attacked one in order, for example, to win a 'debate' or have a timing advantage over the targeted user. This can be done by different means like, init an identical or better tx with an higher gas price, the attacker can also insert himself between the selling price and the purchase with a higher gas price, or prevent someone from performing a tx by overloading the block gas limit.

- **TimeStamp Dependance** : We often need the block.timestamp() to, for example, calculate easily a random numbee, however, the timestamp can be manipulated (to some extent) by the miner because he may or may not choose to mine the block he has discovered. 
