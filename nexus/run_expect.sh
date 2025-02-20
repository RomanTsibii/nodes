#!/usr/bin/expect -f

set timeout -1
# spawn cargo run --release -- --start --beta
spawn cargo run -r -- start --env beta

expect {
    "Do you want to use the existing user account? (y/n)" {
        send "n\r"
        exp_continue
    }
    -re {Enter '2' to start earning NEX} {
        send "2\r"
        exp_continue
    }
    "Please enter your node ID:" {
        set fp [open "/root/.nexus/prover-id" r]
        set node_id [gets $fp]
        close $fp
        send "$node_id\r"
    }
}

interact
