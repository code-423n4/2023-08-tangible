# ✨ So you want to run an audit

This `README.md` contains a set of checklists for our audit collaboration.

Your audit will use two repos: 
- **an _audit_ repo** (this one), which is used for scoping your audit and for providing information to wardens
- **a _findings_ repo**, where issues are submitted (shared with you after the audit) 

Ultimately, when we launch the audit, this repo will be made public and will contain the smart contracts to be reviewed and all the information needed for audit participants. The findings repo will be made public after the audit report is published and your team has mitigated the identified issues.

Some of the checklists in this doc are for **C4 (🐺)** and some of them are for **you as the audit sponsor (⭐️)**.

---

# Audit setup
# Repo setup

## ⭐️ Sponsor: Add code to this repo

- [ ] Create a PR to this repo with the below changes:
- [ ] Provide a self-contained repository with working commands that will build (at least) all in-scope contracts, and commands that will run tests producing gas reports for the relevant contracts.
- [ ] Make sure your code is thoroughly commented using the [NatSpec format](https://docs.soliditylang.org/en/v0.5.10/natspec-format.html#natspec-format).
- [ ] Please have final versions of contracts and documentation added/updated in this repo **no less than 48 business hours prior to audit start time.**
- [ ] Be prepared for a 🚨code freeze🚨 for the duration of the audit — important because it establishes a level playing field. We want to ensure everyone's looking at the same code, no matter when they look during the audit. (Note: this includes your own repo, since a PR can leak alpha to our wardens!)


---

## ⭐️ Sponsor: Edit this README


---

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

[ ⭐️ SPONSORS ADD INFO HERE ]

# Overview

[Docs](https://docs.google.com/document/d/1EWsiBExzqpj9e6e-eLirhBI6A8egqw-dszBHPo2cS5k/edit?usp=sharing))*

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
