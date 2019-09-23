[
    ["record literal(a)",
        [["literal(f1)", "ident(x1)"], ["literal(f2)", "ident(x2)"]]
    ],
    [
        ["var ident(x) ident(y)", 
            ["var ident(y)", 
                ["var ident(z)", 
                    ["nop"]
                ]
            ],
            ["nop"]
        ],
        ["bind ident(x) ident(y)"]
    ]
]
