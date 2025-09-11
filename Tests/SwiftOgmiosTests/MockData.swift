
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
