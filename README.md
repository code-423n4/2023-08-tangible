# Tangible audit details
- Total Prize Pool: $81,500 USDC 
  - HM awards: $41,250 USDC 
  - Analysis awards: $2,500 USDC
  - QA awards: $1,250 USDC 
  - Bot Race awards: $3,750 USDC 
  - Gas awards: $1,250 USDC
  - Judge awards: $9,000 USDC 
  - Lookout awards: $4,000 USDC 
  - Scout awards: $500 USDC 
  - Mitigation Review: $18,000 USDC (*Opportunity goes to top 3 certified wardens based on placement in this audit.*)
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2023-08-tangible/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts August 1, 2023 20:00 UTC
- Ends August 5, 2023 20:00 UTC 

## Automated Findings / Publicly Known Issues

Automated findings output for the audit can be found [here](add link to report) within 24 hours of audit opening.

*Note for C4 wardens: Anything included in the automated findings output is considered a publicly known issue and is ineligible for awards.*

# Introduction

An APR of +200% paid in stables is a rare and extremely attractive product. These returns, paid to locked token voters, are the backbone of the Solidly model, aka ve(3,3) and what makes it so effective. The downside however is that ve(3,3) economics are dense and complicated, challenging for experienced DeFi users and simply beyond the reach of your basic crypto investor.

CAVIAR, a liquid wrapper from Tangible, removes the complexity and commitment of ve(3,3), creating a simple token for nearly any level of crypto investor. Weekly voting, locking, token management and everything else have been fully automated leaving users with single, simple, high-yield token to stake.

# Caviar Overview

CAVIAR ($CVR) is a self-sustaining liquid-wrapper for locked tokens vePEARL, the governance token of the [Pearl Exchange](https://www.pearl.exchange/swap). The main advantage of CAVIAR lies in its streamlined access to outstanding vePEARL yields, paid to voters, and CAVIAR stakers, in the stablecoin $USDR. CAVIAR promises to be a substantial source of income for both the CAVIAR users as well as Tangible 3,3+ locked token holders, who will receive 20% of the vePEARL yield.

## Glossary
- $PEARL: ERC-20 governance token/emission token for Pearl Exchange, an AMM on Polygon
- $vePEARL: ERC-721 tokens (NFTs) containing $PEARL that’s been locked up to 2 years to obtain voting rights on Pearl Exchange
- $CVR: CAVIAR, the liquid-wrapper created by Tangible
- Epoch: A period lasting 7 days, restarting every Thursday at 00:00 GMT
- Rebase: A process on Pearl where up to 50% of weekly emissions are allocated to $vePEARL holders and directly added to their $vePEARL positions
- Bribes: Money deposited in Pearl to entice voters to pick different liquidity pools to receive yield in the form of $PEARL emissions
- Stake: Staking is the process of submitting your CAVIAR into a contract where it can collect bribes. CAVIAR must be staked on Tangible to receive any benefits.
- TNGBL 3,3+: Locked Tangible/$TNGBL the governance token of the Tangible protocol
- $CVR_balance: The balance of CAVIAR in the Pearl stable LP
- $CVR_staked: The total CAVIAR in the staking contract 
- $PEAL_balance: The balance of $PEARL in the Pearl stable LP
- $CVR_total: The total minted supply of CAVIAR

## CAVIAR Explained - How to Use, Redeem and Profit

INSERT IMAGE

Earning triple-digit stablecoin yield has never been easier, it just takes three simple steps:

1. Get CAVIAR: Buy CAVIAR on Pearl or mint it yourself on Tangible, depositing PEARL or vePEARL into our vault.

2. Stake: Stake CAVIAR on Tangible to start earning the highest possible daily yield.

3. Claim: Claim yield any time. Rewards accrue by block and are delivered to your wallet as USDR.

## Minting or Buying CAVIAR
- Mint PEARL → CAVIAR: Users can mint CAVIAR with $PEARL 1:1 at any time on Tangible, no fees or any additional costs other than gas on Polygon.
- Mint vePEARL → CAVIAR: Users can min CAVIAR on Tangible with their vePEARL NFT. Minting with vePEARL incurs a dynamic conversion fee influenced by the CAVIAR - PEARL balance in the stable LP on Pearl Exchange.
- Buy CAVIAR: Users can go to Pearl Exchange to swap any token supported on the exchange for CAVIAR, only paying the standard fees associated with a normal swap plus gas.

## Redeeming or Selling CAVIAR
- Redeem CAVIAR → vePEARL: At any point in time, users can redeem CAVIAR for vePEARL on Tangible, incurring a 3.5% conversion fee plus gas.
- Sell CAVIAR: Users can swap CAVIAR for any token supported on Pearl Exchange, only paying the standard fees associated with a normal swap plus gas.

## Claim CAVIAR Revenue
Unlock the power of triple-digit vePEARL APRs with CAVIAR. Simply stake CAVIAR on Tangible to begin earning yield, which is distributed by block and claimable immediately. All yield is distributed back to users in [USDR](https://docs.tangible.store/real-usd/why-is-real-usd-better-money), Tangible’s native yield stablecoin backed by tokenized real estate.

Using the vePEARL voting power backing CAVIAR and a vote optimizer, we’re able to return the high auto-converting fees, bribes, and rebases into CAVIAR, our innovative distribution system allocates a staggering 81.5% of the voting rewards to the single staking pool, ensuring higher rewards for stakers.

### Bribe Fee

20% of bribes will be converted into USDC and sent to TNGB 3,3+ holders.

### Tangible Marketing Fee

50% of rebase will be sent to Tangible or affiliate marketing partners as an integrated source of funds to support CVR marketing operations.

### Dynamic Conversion Fee

When converting vePEARL to CAVIAR, a dynamic conversion fee is applied. The fee is influenced by the balance of the stable LP on Pearl and ranges from a minimum of 12.5% to a maximum of 70%. The dynamic conversion fee formula is:
`Dynamic fee = ($CVR_balance / $PEARL_balance) * min_conversion_fee`

**Example:**

If the balance in the CAVIAR/PEARL LP is 1000 $PEARL and 2000 $CVR, the conversion fee would be:
`Conversion fee = (2000 / 1000) * 12.5% = 2 * 12.5% = 25%`

## Distribution Formulas
To understand the CAVIAR advantage, let's break down the distribution formulas for the LPs and staking pool.

1. Calculate `CVR_total:`
   
`CVR_total = CVR_Balance + CVR_staked`

2. Calculate `LPs Distribution:`
   
`LPs Distribution = (CVR_LP_balance / CVR_total) * (Rebase/2)`

3. Calculate `Staking Distribution:`

`Staking Distribution = (Rebase/2) - LPs Distribution`

**Example:**

Assuming `CVR_LP_balance` is 500, `CVR_staked` is 400, and `Rebase` is 100:

`CVR_total = 500 + 400 = 900 LPs Distribution = (500 / 900) * (100/2) = 27.78`

`Staking Distribution = (100/2) - 27.78 = 22.22`

## Bootstrapping CAVIAR: Low-Fee Promotional Window

For a limited time, users can convert vePEARL into CAVIAR for a static 5% fee, capped at 4,000,000 vePEARL.

# Scope

      26 text files.
      26 unique files.                              
       0 files ignored.

github.com/AlDanial/cloc v 1.96  T=0.02 s (1154.6 files/s, 81487.2 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Solidity                        26            361            113           1361
-------------------------------------------------------------------------------
SUM:                            26            361            113           1361
-------------------------------------------------------------------------------

## Out of scope

*List any files/contracts that are out of scope for this audit.*

# Additional Context

*Describe any novel or unique curve logic or mathematical models implemented in the contracts*

*Sponsor, please confirm/edit the information below.*

## Scoping Details 
```
- If you have a public code repo, please share it here: https://github.com/moogito/Caviar/tree/main/contracts 
- How many contracts are in scope?: 26  
- Total SLoC for these contracts?: 1503 
- How many external imports are there?:  1
- How many separate interfaces and struct definitions are there for the contracts within scope?:  10 interfaces, 3 structs
- Does most of your code generally use composition or inheritance?:   Composition
- How many external calls?: 1 
- What is the overall line coverage percentage provided by your tests?: 0%
- Is this an upgrade of an existing system?: No
- Check all that apply (e.g. timelock, NFT, AMM, ERC20, rollups, etc.): NFT, AMM, ERC-20 Token, Timelock function, Side chain
- Is there a need to understand a separate part of the codebase / get context in order to audit this part of the protocol?: Yes  
- Please describe required context: Solidly / ve(3,3) AMMs   
- Does it use an oracle?:  No
- Describe any novel or unique curve logic or mathematical models your code uses: N/A
- Is this either a fork of or an alternate implementation of another project?: Yes. Alt implementation of liveTHE liquid wrapper. We've changed the rebase distribution, 50% go to a marketing fund. The allocation % to TNGBL holders is higher than it was to mxLQDR holders. The autobribe allocation to the LP has been removed. All voting yields are being converted to USDR (one token for all Caviar rewards.)  
- Does it use a side-chain?: Yes. EVM-compatible side-chain
- Describe any specific areas you would like addressed:  1 - Anything that would lead to loss of funds, 2 - There may be a way to circumvent the sliding fee for minting with vePEARL by using flash loans.
```

# Tests

*Provide every step required to build the project from a fresh git clone, as well as steps to run the tests with a gas report.* 

*Note: Many wardens run Slither as a first pass for testing.  Please document any known errors with no workaround.* 
