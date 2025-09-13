
let mockEpoch = """
{
  "result" : 1052,
  "method" : "queryLedgerState/epoch",
  "id" : "5ZrIS",
  "jsonrpc" : "2.0"
}
""".data(using: .utf8)!

let mockConstitution = """
{
  "id" : "AbNq3",
  "jsonrpc" : "2.0",
  "method" : "queryLedgerState/constitution",
  "result" : {
    "guardrails" : {
      "hash" : "fa24fb305126805cf2164c161d852a0e7330cf988f1fe558cf7d4a64"
    },
    "metadata" : {
      "hash" : "ca41a91f399259bcefe57f9858e91f6d00e1a38d6d9c63d4052914ea7bd70cb2",
      "url" : "ipfs://bafkreifnwj6zpu3ixa4siz2lndqybyc5wnnt3jkwyutci4e2tmbnj3xrdm"
    }
  }
}
""".data(using: .utf8)!

let mockConstitutionalCommittee = """
{
  "id" : "5pcVz",
  "jsonrpc" : "2.0",
  "result" : {
    "members" : [
      {
        "mandate" : {
          "epoch" : 1007
        },
        "id" : "01a3c5b09f4b915a2f7f865daa1b601cd2b7c55c33fa616d11a9a9d2",
        "status" : "expired",
        "delegate" : {
          "status" : "authorized",
          "from" : "script",
          "id" : "0c5d713c61a09e05d5f975aabf73f8e699ea7ed004141fd4ece6f8d2"
        },
        "from" : "script"
      }
    ],
    "quorum" : "2/3"
  },
  "method" : "queryLedgerState/constitutionalCommittee"
}
""".data(using: .utf8)!


let mockDelegateRepresentatives = """
{
  "jsonrpc" : "2.0",
  "method" : "queryLedgerState/delegateRepresentatives",
  "id" : "zXWtP",
  "result" : [
    {
      "from" : "verificationKey",
      "id" : "000e058ed523b3c64865089580f1604e13178f5df2bee538e1b96203",
      "deposit" : {
        "ada" : {
          "lovelace" : 500000000
        }
      },
      "type" : "registered",
      "stake" : {
        "ada" : {
          "lovelace" : 0
        }
      },
      "mandate" : {
        "epoch" : 1068
      },
      "metadata" : {
        "hash" : "b5f8f69913ca29e453f2ac9fd0d2a906e2f50f75d14ee78d2afb08cbb5a96294",
        "url" : "https://metadata-govtool.cardanoapi.io/data/Justine"
      },
      "delegators" : [

      ]
    },
    {
      "stake" : {
        "ada" : {
          "lovelace" : 46115228289209
        }
      },
      "type" : "abstain"
    },
    {
      "stake" : {
        "ada" : {
          "lovelace" : 15049380877790
        }
      },
      "type" : "noConfidence"
    }
  ]
}
""".data(using: .utf8)!

let mockDump = """
{
  "jsonrpc" : "2.0",
  "method" : "queryLedgerState/dump",
  "id" : "vHglH"
}
""".data(using: .utf8)!

let mockEraStart = """
{
  "id" : "N~xS6",
  "method" : "queryLedgerState/eraStart",
  "jsonrpc" : "2.0",
  "result" : {
    "slot" : 55814400,
    "epoch" : 646,
    "time" : {
      "seconds" : 55814400
    }
  }
}
""".data(using: .utf8)!

let mockEraSummaries = """
{
  "jsonrpc" : "2.0",
  "result" : [
    {
      "parameters" : {
        "epochLength" : 4320,
        "slotLength" : {
          "milliseconds" : 20000
        },
        "safeZone" : 864
      },
      "start" : {
        "slot" : 0,
        "time" : {
          "seconds" : 0
        },
        "epoch" : 0
      },
      "end" : {
        "slot" : 0,
        "time" : {
          "seconds" : 0
        },
        "epoch" : 0
      }
    }
  ],
  "id" : "7eoEB",
  "method" : "queryLedgerState/eraSummaries"
}
""".data(using: .utf8)!

let mockGovernanceProposals = """
{
  "jsonrpc" : "2.0",
  "id" : "OmNgj",
  "result" : [
    {
      "votes" : [
        {
          "vote" : "no",
          "issuer" : {
            "id" : "ab0d62f6646c980cde6fd65b4a5bb7cbfc8c2b2dabea61f4b46737a5",
            "from" : "verificationKey",
            "role" : "delegateRepresentative"
          }
        },
        {
          "vote" : "yes",
          "issuer" : {
            "role" : "delegateRepresentative",
            "id" : "b1186c121f6a75f3ba749aa5b1e50b41b9be1726f3306ece7d77d4c1",
            "from" : "verificationKey"
          }
        }
      ],
      "action" : {
        "type" : "treasuryWithdrawals",
        "withdrawals" : {
          "stake_test1up8xg8ur80nsymvefrlk4dshjyfrze4pep843l289f4n8fgrtrmy4" : {
            "ada" : {
              "lovelace" : 889000000
            }
          }
        },
        "guardrails" : {
          "hash" : "fa24fb305126805cf2164c161d852a0e7330cf988f1fe558cf7d4a64"
        }
      },
      "deposit" : {
        "ada" : {
          "lovelace" : 100000000000
        }
      },
      "returnAccount" : "stake_test1up8xg8ur80nsymvefrlk4dshjyfrze4pep843l289f4n8fgrtrmy4",
      "proposal" : {
        "index" : 0,
        "transaction" : {
          "id" : "910199f3c5a5d58c2342285fc40837a0f7041925580705f3adc083ece0f06d3d"
        }
      },
      "metadata" : {
        "url" : "https://metadata-govtool.cardanoapi.io/data/decumbo",
        "hash" : "866a28625ad0a73892c4a7956f4400e59354d7d9281721bb2c15dbe67ef97d3b"
      },
      "since" : {
        "epoch" : 1021
      },
      "until" : {
        "epoch" : 1051
      }
    }
  ],
  "method" : "queryLedgerState/governanceProposals"
}
""".data(using: .utf8)!

let mockLiveStakeDistribution = """
{
  "jsonrpc" : "2.0",
  "method" : "queryLedgerState/liveStakeDistribution",
  "id" : "test123",
  "result" : {
    "pool104teu8tjj33a3lqct3f7ac9hl6e8d9muc548k3vvavadvk6s3pc" : {
      "stake" : "2497472301/36061816661970035",
      "vrf" : "44b93933fc9cba358fdc9bab0f9b5762ecf31c5a32fcdfad63ea2ff9bc385f07"
    },
    "pool1057njzaaz280688ppewa3df4qshspvh98njh5n4lq4cg7ntcsyj" : {
      "stake" : "2504340370/7212363332394007",
      "vrf" : "a63ae2342ab8c541978c1f12f0a2338b78b1486c9c6fcdc5d516df4f08bbd93f"
    },
    "pool105wx68zqse6v4wyx09nkqhxhmf7e0zj349pclyqsjqch7953j0x" : {
      "stake" : "8448765625/7212363332394007",
      "vrf" : "7b0cb25a2a5abf1a97523355002a173cd9ff4b2108b7ace2b4693ee406b06eef"
    }
  }
}
""".data(using: .utf8)!

let nonces = """
{
  "jsonrpc" : "2.0",
  "method" : "queryLedgerState/nonces",
  "result" : {
    "evolvingNonce" : "72714536007d2def6a7a1b79bd17592543f3efb90e9aa13141112c32eb4b9212",
    "candidateNonce" : "3eb915da53048a87e778fae56b7dc2994f4fe7613b3b6d3f6763c901ed7eb997",
    "lastEpochLastAncestor" : "ea11b55edb98434c073243df5abdb9040a95239736a644daeac75b3ba1b6097b",
    "epochNonce" : "eda75fda2a45f816e76413a04d2dc207c214b88d8141b8d3003767d6b3913b97"
  },
  "id" : "GB3ng"
}
""".data(using: .utf8)!

let operationalCertificates = """
{
  "jsonrpc" : "2.0",
  "id" : "4tKK9",
  "method" : "queryLedgerState/operationalCertificates",
  "result" : {
    "pool1ssvpmsymcz8nd6tu3wgdhy93ajw0yrdauh9gp3djxvda5g6nqma" : 0,
    "pool14cwzrv0mtr68kp44t9fn5wplk9ku20g6rv98sxggd3azg60qukm" : 6,
    "pool18ut2jlv66s0dh70pp4za2pu42dg57jynflkj9fexamcfqcsmc5q" : 0,
    "pool1d4nsv4wa0h3cvdkzuj7trx9d3gz93cj4hkslhekhq0wmcdpwmps" : 10,
    "pool1sqva3m6zhvwf9kmuek7gsayxyknzv68ltgqqpeptmdgrqp2lmkf" : 4,
    "pool1397kpa7ylzg4lqrmj3xr28xzq2548c8lafw90qyxvucsslap03v" : 12,
    
  }
}
""".data(using: .utf8)!

let projectedRewards = """
{
    "jsonrpc": "2.0",
    "method": "queryLedgerState/projectedRewards",
    "result": {
        "10000000": {
            "pool1qqa8tkycj4zck4sy7n8mqr22x5g7tvm8hnp9st95wmuvvtw28th": {
                "ada": {
                    "lovelace": 2537
                }
            },
            "pool1qzq896ke4meh0tn9fl0dcnvtn2rzdz75lk3h8nmsuew8z5uln7r": {
                "ada": {
                    "lovelace": 2535
                }
            }
        }
    },
    "id": null
}
""".data(using: .utf8)!


let protocolParameters = """
{
    "jsonrpc": "2.0",
    "method": "queryLedgerState/protocolParameters",
    "result": {
        "minFeeCoefficient": 44,
        "minFeeConstant": {
            "ada": {
                "lovelace": 155381
            }
        },
        "minFeeReferenceScripts": {
            "base": 15.0,
            "range": 25600,
            "multiplier": 1.2
        },
        "maxBlockBodySize": {
            "bytes": 90112
        },
        "maxBlockHeaderSize": {
            "bytes": 1100
        },
        "maxTransactionSize": {
            "bytes": 16384
        },
        "maxReferenceScriptsSize": {
            "bytes": 204800
        },
        "stakeCredentialDeposit": {
            "ada": {
                "lovelace": 2000000
            }
        },
        "stakePoolDeposit": {
            "ada": {
                "lovelace": 500000000
            }
        },
        "stakePoolRetirementEpochBound": 18,
        "desiredNumberOfStakePools": 500,
        "stakePoolPledgeInfluence": "3/10",
        "monetaryExpansion": "3/1000",
        "treasuryExpansion": "1/5",
        "minStakePoolCost": {
            "ada": {
                "lovelace": 170000000
            }
        },
        "minUtxoDepositConstant": {
            "ada": {
                "lovelace": 0
            }
        },
        "minUtxoDepositCoefficient": 4310,
        "plutusCostModels": {
            "plutus:v1": [
                100788,
                420,
                1,
                1,
                1000,
                173,
                0,
                1,
                1000,
                59957,
                4,
                1,
                11183,
                32,
                201305,
                8356,
                4,
                16000,
                100,
                16000,
                100,
                16000,
                100,
                16000,
                100,
                16000,
                100,
                16000,
                100,
                100,
                100,
                16000,
                100,
                94375,
                32,
                132994,
                32,
                61462,
                4,
                72010,
                178,
                0,
                1,
                22151,
                32,
                91189,
                769,
                4,
                2,
                85848,
                228465,
                122,
                0,
                1,
                1,
                1000,
                42921,
                4,
                2,
                24548,
                29498,
                38,
                1,
                898148,
                27279,
                1,
                51775,
                558,
                1,
                39184,
                1000,
                60594,
                1,
                141895,
                32,
                83150,
                32,
                15299,
                32,
                76049,
                1,
                13169,
                4,
                22100,
                10,
                28999,
                74,
                1,
                28999,
                74,
                1,
                43285,
                552,
                1,
                44749,
                541,
                1,
                33852,
                32,
                68246,
                32,
                72362,
                32,
                7243,
                32,
                7391,
                32,
                11546,
                32,
                85848,
                228465,
                122,
                0,
                1,
                1,
                90434,
                519,
                0,
                1,
                74433,
                32,
                85848,
                228465,
                122,
                0,
                1,
                1,
                85848,
                228465,
                122,
                0,
                1,
                1,
                270652,
                22588,
                4,
                1457325,
                64566,
                4,
                20467,
                1,
                4,
                0,
                141992,
                32,
                100788,
                420,
                1,
                1,
                81663,
                32,
                59498,
                32,
                20142,
                32,
                24588,
                32,
                20744,
                32,
                25933,
                32,
                24623,
                32,
                53384111,
                14333,
                10
            ],
            "plutus:v2": [
                100788,
                420,
                1,
                1,
                1000,
                173,
                0,
                1,
                1000,
                59957,
                4,
                1,
                11183,
                32,
                201305,
                8356,
                4,
                16000,
                100,
                16000,
                100,
                16000,
                100,
                16000,
                100,
                16000,
                100,
                16000,
                100,
                100,
                100,
                16000,
                100,
                94375,
                32,
                132994,
                32,
                61462,
                4,
                72010,
                178,
                0,
                1,
                22151,
                32,
                91189,
                769,
                4,
                2,
                85848,
                228465,
                122,
                0,
                1,
                1,
                1000,
                42921,
                4,
                2,
                24548,
                29498,
                38,
                1,
                898148,
                27279,
                1,
                51775,
                558,
                1,
                39184,
                1000,
                60594,
                1,
                141895,
                32,
                83150,
                32,
                15299,
                32,
                76049,
                1,
                13169,
                4,
                22100,
                10,
                28999,
                74,
                1,
                28999,
                74,
                1,
                43285,
                552,
                1,
                44749,
                541,
                1,
                33852,
                32,
                68246,
                32,
                72362,
                32,
                7243,
                32,
                7391,
                32,
                11546,
                32,
                85848,
                228465,
                122,
                0,
                1,
                1,
                90434,
                519,
                0,
                1,
                74433,
                32,
                85848,
                228465,
                122,
                0,
                1,
                1,
                85848,
                228465,
                122,
                0,
                1,
                1,
                955506,
                213312,
                0,
                2,
                270652,
                22588,
                4,
                1457325,
                64566,
                4,
                20467,
                1,
                4,
                0,
                141992,
                32,
                100788,
                420,
                1,
                1,
                81663,
                32,
                59498,
                32,
                20142,
                32,
                24588,
                32,
                20744,
                32,
                25933,
                32,
                24623,
                32,
                43053543,
                10,
                53384111,
                14333,
                10,
                43574283,
                26308,
                10
            ],
            "plutus:v3": [
                100788,
                420,
                1,
                1,
                1000,
                173,
                0,
                1,
                1000,
                59957,
                4,
                1,
                11183,
                32,
                201305,
                8356,
                4,
                16000,
                100,
                16000,
                100,
                16000,
                100,
                16000,
                100,
                16000,
                100,
                16000,
                100,
                100,
                100,
                16000,
                100,
                94375,
                32,
                132994,
                32,
                61462,
                4,
                72010,
                178,
                0,
                1,
                22151,
                32,
                91189,
                769,
                4,
                2,
                85848,
                123203,
                7305,
                -900,
                1716,
                549,
                57,
                85848,
                0,
                1,
                1,
                1000,
                42921,
                4,
                2,
                24548,
                29498,
                38,
                1,
                898148,
                27279,
                1,
                51775,
                558,
                1,
                39184,
                1000,
                60594,
                1,
                141895,
                32,
                83150,
                32,
                15299,
                32,
                76049,
                1,
                13169,
                4,
                22100,
                10,
                28999,
                74,
                1,
                28999,
                74,
                1,
                43285,
                552,
                1,
                44749,
                541,
                1,
                33852,
                32,
                68246,
                32,
                72362,
                32,
                7243,
                32,
                7391,
                32,
                11546,
                32,
                85848,
                123203,
                7305,
                -900,
                1716,
                549,
                57,
                85848,
                0,
                1,
                90434,
                519,
                0,
                1,
                74433,
                32,
                85848,
                123203,
                7305,
                -900,
                1716,
                549,
                57,
                85848,
                0,
                1,
                1,
                85848,
                123203,
                7305,
                -900,
                1716,
                549,
                57,
                85848,
                0,
                1,
                955506,
                213312,
                0,
                2,
                270652,
                22588,
                4,
                1457325,
                64566,
                4,
                20467,
                1,
                4,
                0,
                141992,
                32,
                100788,
                420,
                1,
                1,
                81663,
                32,
                59498,
                32,
                20142,
                32,
                24588,
                32,
                20744,
                32,
                25933,
                32,
                24623,
                32,
                43053543,
                10,
                53384111,
                14333,
                10,
                43574283,
                26308,
                10,
                16000,
                100,
                16000,
                100,
                962335,
                18,
                2780678,
                6,
                442008,
                1,
                52538055,
                3756,
                18,
                267929,
                18,
                76433006,
                8868,
                18,
                52948122,
                18,
                1995836,
                36,
                3227919,
                12,
                901022,
                1,
                166917843,
                4307,
                36,
                284546,
                36,
                158221314,
                26549,
                36,
                74698472,
                36,
                333849714,
                1,
                254006273,
                72,
                2174038,
                72,
                2261318,
                64571,
                4,
                207616,
                8310,
                4,
                1293828,
                28716,
                63,
                0,
                1,
                1006041,
                43623,
                251,
                0,
                1,
                100181,
                726,
                719,
                0,
                1,
                100181,
                726,
                719,
                0,
                1,
                100181,
                726,
                719,
                0,
                1,
                107878,
                680,
                0,
                1,
                95336,
                1,
                281145,
                18848,
                0,
                1,
                180194,
                159,
                1,
                1,
                158519,
                8942,
                0,
                1,
                159378,
                8813,
                0,
                1,
                107490,
                3298,
                1,
                106057,
                655,
                1,
                1964219,
                24520,
                3
            ]
        },
        "scriptExecutionPrices": {
            "memory": "577/10000",
            "cpu": "721/10000000"
        },
        "maxExecutionUnitsPerTransaction": {
            "memory": 14000000,
            "cpu": 10000000000
        },
        "maxExecutionUnitsPerBlock": {
            "memory": 62000000,
            "cpu": 20000000000
        },
        "maxValueSize": {
            "bytes": 5000
        },
        "collateralPercentage": 150,
        "maxCollateralInputs": 3,
        "version": {
            "major": 10,
            "minor": 0
        },
        "stakePoolVotingThresholds": {
            "noConfidence": "51/100",
            "constitutionalCommittee": {
                "default": "51/100",
                "stateOfNoConfidence": "51/100"
            },
            "hardForkInitiation": "51/100",
            "protocolParametersUpdate": {
                "security": "51/100"
            }
        },
        "delegateRepresentativeVotingThresholds": {
            "noConfidence": "67/100",
            "constitutionalCommittee": {
                "default": "67/100",
                "stateOfNoConfidence": "3/5"
            },
            "constitution": "3/4",
            "hardForkInitiation": "3/5",
            "protocolParametersUpdate": {
                "network": "67/100",
                "economic": "67/100",
                "technical": "67/100",
                "governance": "3/4"
            },
            "treasuryWithdrawals": "67/100"
        },
        "constitutionalCommitteeMinSize": 3,
        "constitutionalCommitteeMaxTermLength": 365,
        "governanceActionLifetime": 30,
        "governanceActionDeposit": {
            "ada": {
                "lovelace": 100000000000
            }
        },
        "delegateRepresentativeDeposit": {
            "ada": {
                "lovelace": 500000000
            }
        },
        "delegateRepresentativeMaxIdleTime": 31
    },
    "id": null
}
""".data(using: .utf8)!


let proposedProtocolParameters = """
{
  "jsonrpc": "2.0",
  "method": "queryLedgerState/proposedProtocolParameters",
  "result": [
    {
      "minFeeCoefficient": 18446744073709552,
      "minFeeConstant": {
        "ada": {
          "lovelace": 0
        }
      },
      "minFeeReferenceScripts": {
        "range": 4294967295,
        "base": 0,
        "multiplier": 0
      },
      "minUtxoDepositCoefficient": 123,
      "minUtxoDepositConstant": {
        "ada": {
          "lovelace": 0
        }
      },
      "maxBlockBodySize": {
        "bytes": 18446744073709552
      },
      "maxBlockHeaderSize": {
        "bytes": 18446744073709552
      },
      "maxTransactionSize": {
        "bytes": 18446744073709552
      },
      "maxReferenceScriptsSize": {
        "bytes": 18446744073709552
      },
      "maxValueSize": {
        "bytes": 18446744073709552
      },
      "extraEntropy": "neutral",
      "stakeCredentialDeposit": {
        "ada": {
          "lovelace": 0
        }
      },
      "stakePoolDeposit": {
        "ada": {
          "lovelace": 0
        }
      },
      "stakePoolRetirementEpochBound": 18446744073709552,
      "stakePoolPledgeInfluence": "2/3",
      "minStakePoolCost": {
        "ada": {
          "lovelace": 0
        }
      },
      "desiredNumberOfStakePools": 18446744073709552,
      "federatedBlockProductionRatio": "2/3",
      "monetaryExpansion": "2/3",
      "treasuryExpansion": "2/3",
      "collateralPercentage": 18446744073709552,
      "maxCollateralInputs": 18446744073709552,
      "plutusCostModels": {
        "plutus:v1": [
          14,
          123
        ],
        "plutus:v2": [
          14,
          42,
          131
        ]
      },
      "scriptExecutionPrices": {
        "memory": "2/3",
        "cpu": "2/3"
      },
      "maxExecutionUnitsPerTransaction": {
        "memory": 18446744073709552,
        "cpu": 18446744073709552
      },
      "maxExecutionUnitsPerBlock": {
        "memory": 18446744073709552,
        "cpu": 18446744073709552
      },
      "stakePoolVotingThresholds": {
        "noConfidence": "2/3",
        "constitutionalCommittee": {
          "default": "2/3",
          "stateOfNoConfidence": "2/3"
        },
        "hardForkInitiation": "2/3",
        "protocolParametersUpdate": {
          "security": "2/3"
        }
      },
      "constitutionalCommitteeMinSize": 65536,
      "constitutionalCommitteeMaxTermLength": 18446744073709552,
      "governanceActionLifetime": 18446744073709552,
      "governanceActionDeposit": {
        "ada": {
          "lovelace": 0
        }
      },
      "delegateRepresentativeVotingThresholds": {
        "noConfidence": "2/3",
        "constitution": "2/3",
        "constitutionalCommittee": {
          "default": "2/3",
          "stateOfNoConfidence": "2/3"
        },
        "hardForkInitiation": "2/3",
        "protocolParametersUpdate": {
          "network": "2/3",
          "economic": "2/3",
          "technical": "2/3",
          "governance": "2/3"
        },
        "treasuryWithdrawals": "2/3"
      },
      "delegateRepresentativeDeposit": {
        "ada": {
          "lovelace": 0
        }
      },
      "delegateRepresentativeMaxIdleTime": 18446744073709552,
      "version": {
        "major": 4294967295,
        "minor": 4294967295,
        "patch": 4294967295
      }
    }
  ],
  "id": null
}
""".data(using: .utf8)!


let rewardAccountSummaries = """
{
    "jsonrpc": "2.0",
    "method": "queryLedgerState/rewardAccountSummaries",
    "result": [
        {
            "from": "verificationKey",
            "credential": "1b515807ebb8a99331ddeb20395267e83f29b80716ada5ea37c0a062",
            "stakePool": {
                "id": "pool1vezalga3ge0mt0xf4txz66ctufk6nrmemhhpshwkhedk5jf0stw"
            },
            "delegateRepresentative": {
                "type": "registered",
                "from": "verificationKey",
                "id": "3e831562e3760f6fa2628154d1c7dc21798edb210152bd52659e201f"
            },
            "rewards": {
                "ada": {
                    "lovelace": 91570554888
                }
            },
            "deposit": {
                "ada": {
                    "lovelace": 2000000
                }
            }
        }
    ],
    "id": null
}
""".data(using: .utf8)!


let rewardsProvenance = """
{
    "jsonrpc": "2.0",
    "method": "queryLedgerState/rewardsProvenance",
    "result": {
        "desiredNumberOfStakePools": 500,
        "stakePoolPledgeInfluence": "3/10",
        "totalRewardsInEpoch": {
            "ada": {
                "lovelace": 13695546392205
            }
        },
        "activeStakeInEpoch": {
            "ada": {
                "lovelace": 950528788771851
            }
        },
        "totalStakeInEpoch": {
            "ada": {
                "lovelace": 36069364086442721
            }
        },
        "stakePools": {
            "pool1qqa8tkycj4zck4sy7n8mqr22x5g7tvm8hnp9st95wmuvvtw28th": {
                "id": "pool1qqa8tkycj4zck4sy7n8mqr22x5g7tvm8hnp9st95wmuvvtw28th",
                "stake": {
                    "ada": {
                        "lovelace": 13492420330
                    }
                },
                "ownerStake": {
                    "ada": {
                        "lovelace": 2497634194
                    }
                },
                "approximatePerformance": 0.885,
                "parameters": {
                    "cost": {
                        "ada": {
                            "lovelace": 340000000
                        }
                    },
                    "margin": "0/1",
                    "pledge": {
                        "ada": {
                            "lovelace": 500000000
                        }
                    }
                }
            },
            "pool1qzq896ke4meh0tn9fl0dcnvtn2rzdz75lk3h8nmsuew8z5uln7r": {
                "id": "pool1qzq896ke4meh0tn9fl0dcnvtn2rzdz75lk3h8nmsuew8z5uln7r",
                "stake": {
                    "ada": {
                        "lovelace": 1997639694
                    }
                },
                "ownerStake": {
                    "ada": {
                        "lovelace": 1997639694
                    }
                },
                "approximatePerformance": 0.885,
                "parameters": {
                    "cost": {
                        "ada": {
                            "lovelace": 170000000
                        }
                    },
                    "margin": "1/100",
                    "pledge": {
                        "ada": {
                            "lovelace": 1000000000
                        }
                    }
                }
            },
            "pool1lleyxf5xxaxg633c2thh5ttjrf4qxrm3cqaw53kmp7e5q2nlg38": {
                "id": "pool1lleyxf5xxaxg633c2thh5ttjrf4qxrm3cqaw53kmp7e5q2nlg38",
                "stake": {
                    "ada": {
                        "lovelace": 10002942939
                    }
                },
                "ownerStake": {
                    "ada": {
                        "lovelace": 10000000000
                    }
                },
                "approximatePerformance": 0.885,
                "parameters": {
                    "cost": {
                        "ada": {
                            "lovelace": 340000000
                        }
                    },
                    "margin": "3/10",
                    "pledge": {
                        "ada": {
                            "lovelace": 100000000000
                        }
                    }
                }
            }
        }
    },
    "id": null
}
""".data(using: .utf8)!


let stakePoolsPerformances = """
{
    "jsonrpc": "2.0",
    "method": "queryLedgerState/stakePoolsPerformances",
    "result": {
        "desiredNumberOfStakePools": 500,
        "stakePoolPledgeInfluence": "3/10",
        "totalRewardsInEpoch": {
            "ada": {
                "lovelace": 13695546392205
            }
        },
        "activeStakeInEpoch": {
            "ada": {
                "lovelace": 950528788771851
            }
        },
        "totalStakeInEpoch": {
            "ada": {
                "lovelace": 36069364086442721
            }
        },
        "stakePools": {
            "pool1qqa8tkycj4zck4sy7n8mqr22x5g7tvm8hnp9st95wmuvvtw28th": {
                "id": "pool1qqa8tkycj4zck4sy7n8mqr22x5g7tvm8hnp9st95wmuvvtw28th",
                "stake": {
                    "ada": {
                        "lovelace": 13492420330
                    }
                },
                "ownerStake": {
                    "ada": {
                        "lovelace": 2497634194
                    }
                },
                "approximatePerformance": 0.885,
                "parameters": {
                    "cost": {
                        "ada": {
                            "lovelace": 340000000
                        }
                    },
                    "margin": "0/1",
                    "pledge": {
                        "ada": {
                            "lovelace": 500000000
                        }
                    }
                }
            },
            "pool1qzq896ke4meh0tn9fl0dcnvtn2rzdz75lk3h8nmsuew8z5uln7r": {
                "id": "pool1qzq896ke4meh0tn9fl0dcnvtn2rzdz75lk3h8nmsuew8z5uln7r",
                "stake": {
                    "ada": {
                        "lovelace": 1997639694
                    }
                },
                "ownerStake": {
                    "ada": {
                        "lovelace": 1997639694
                    }
                },
                "approximatePerformance": 0.885,
                "parameters": {
                    "cost": {
                        "ada": {
                            "lovelace": 170000000
                        }
                    },
                    "margin": "1/100",
                    "pledge": {
                        "ada": {
                            "lovelace": 1000000000
                        }
                    }
                }
            },
            "pool1lleyxf5xxaxg633c2thh5ttjrf4qxrm3cqaw53kmp7e5q2nlg38": {
                "id": "pool1lleyxf5xxaxg633c2thh5ttjrf4qxrm3cqaw53kmp7e5q2nlg38",
                "stake": {
                    "ada": {
                        "lovelace": 10002942939
                    }
                },
                "ownerStake": {
                    "ada": {
                        "lovelace": 10000000000
                    }
                },
                "approximatePerformance": 0.885,
                "parameters": {
                    "cost": {
                        "ada": {
                            "lovelace": 340000000
                        }
                    },
                    "margin": "3/10",
                    "pledge": {
                        "ada": {
                            "lovelace": 100000000000
                        }
                    }
                }
            }
        }
    },
    "id": null
}
""".data(using: .utf8)!


let utxo = """
{
    "jsonrpc": "2.0",
    "method": "queryLedgerState/utxo",
    "result": [
        {
            "transaction": {
                "id": "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef"
            },
            "index": 0,
            "address": "addr_test1qz66ue36465w2qq40005h2hadad6pnjht8mu6sgplsfj74qdjnshguewlx4ww0eet26y2pal4xpav5prcydf28cvxtjqx46x7f",
            "value": {
                "ada": {
                    "lovelace": 2000000
                }
            }
        },
        {
            "transaction": {
                "id": "abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890"
            },
            "index": 1,
            "address": "addr_test1qqag3ume6wap6ywjhgs5g25fkrs4cq90dqtqsz8hs0l4x2k5vgk3l7gpqvxpg2qwqjv2f8g3jv8j8j9v2lq3l5x3j5x3z5j7w",
            "value": {
                "ada": {
                    "lovelace": 5000000
                },
                "3542acb3a64d80c29302260d62c3b87a742ad14abf855ebc6733081e": {
                    "546f6b656e41": 100
                },
                "b5ae663aaea8e500157bdf4baafd6f5ba0ce5759f7cd4101fc132f54": {
                    "706174617465": 1337
                }
            },
            "datumHash": "9e478573ab81ea7a8e31891ce0648b81229f408dcbf5b2b5516a89b9c0ce1f23"
        },
        {
            "transaction": {
                "id": "fedcba0987654321fedcba0987654321fedcba0987654321fedcba0987654321"
            },
            "index": 2,
            "address": "addr_test1qpxg2rqx4q5q5q5q5q5q5q5q5q5q5q5q5q5q5q5q5q5q5q5q5q5q5q5q5q5q5z5x7v3",
            "value": {
                "ada": {
                    "lovelace": 10000000
                }
            },
            "script": {
                "language": "plutus:v2",
                "cbor": "59015859015501000032323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232"
            }
        }
    ],
    "id": null
}
""".data(using: .utf8)!

let stakePools = """
{
    "jsonrpc": "2.0",
    "method": "queryLedgerState/stakePools",
    "result": {
        "pool1qqa8tkycj4zck4sy7n8mqr22x5g7tvm8hnp9st95wmuvvtw28th": {
            "id": "pool1qqa8tkycj4zck4sy7n8mqr22x5g7tvm8hnp9st95wmuvvtw28th",
            "vrfVerificationKeyHash": "44b93933fc9cba358fdc9bab0f9b5762ecf31c5a32fcdfad63ea2ff9bc385f07",
            "owners": [
                "1b515807ebb8a99331ddeb20395267e83f29b80716ada5ea37c0a062"
            ],
            "cost": {
                "ada": {
                    "lovelace": 340000000
                }
            },
            "margin": "0/1",
            "pledge": {
                "ada": {
                    "lovelace": 500000000
                }
            },
            "rewardAccount": "stake1u8yxtugdv63wxafy9d00nuz6hjyyp4qnggvc9a3vxh8yl0qcqpj",
            "metadata": {
                "url": "https://example.com/pool-metadata.json",
                "hash": "b5f8f69913ca29e453f2ac9fd0d2a906e2f50f75d14ee78d2afb08cbb5a96294"
            },
            "relays": [
                {
                    "type": "singleHostName",
                    "hostname": "relay.example.com",
                    "port": 3001
                }
            ],
            "stake": {
                "ada": {
                    "lovelace": 13492420330
                }
            }
        },
        "pool1qzq896ke4meh0tn9fl0dcnvtn2rzdz75lk3h8nmsuew8z5uln7r": {
            "id": "pool1qzq896ke4meh0tn9fl0dcnvtn2rzdz75lk3h8nmsuew8z5uln7r",
            "vrfVerificationKeyHash": "a63ae2342ab8c541978c1f12f0a2338b78b1486c9c6fcdc5d516df4f08bbd93f",
            "owners": [
                "2c234567abb8a99331ddeb20395267e83f29b80716ada5ea37c0a062"
            ],
            "cost": {
                "ada": {
                    "lovelace": 170000000
                }
            },
            "margin": "1/100",
            "pledge": {
                "ada": {
                    "lovelace": 1000000000
                }
            },
            "rewardAccount": "stake1u9yxtugdv63wxafy9d00nuz6hjyyp4qnggvc9a3vxh8yl0qcqpk",
            "relays": [
                {
                    "type": "singleHostAddr",
                    "ipv4": "192.168.1.100",
                    "port": 3001
                }
            ]
        }
    },
    "id": null
}
""".data(using: .utf8)!

let treasuryAndReserves = """
{
    "jsonrpc": "2.0",
    "method": "queryLedgerState/treasuryAndReserves",
    "result": {
        "treasury": {
            "ada": {
                "lovelace": 5891303965843822
            }
        },
        "reserves": {
            "ada": {
                "lovelace": 8930635913557279
            }
        }
    },
    "id": null
}
""".data(using: .utf8)!

let tip = """
{
  "method" : "queryLedgerState/tip",
  "jsonrpc" : "2.0",
  "result" : {
    "id" : "4dc5188a99ce636e624ab72104f6f18031dcd849c151ce1c8ef4871b7c3913b9",
    "slot" : 90918798
  },
  "id" : "9mkRM"
}
""".data(using: .utf8)!
