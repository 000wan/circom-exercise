#!/bin/bash

# [assignment] create your own bash script to compile Multiplier3.circom using PLONK below

cd contracts/circuits

mkdir Multiplier3_plonk

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling Multiplier3.circom..."

# compile circuit
circom Multiplier3.circom --r1cs --wasm --sym -o Multiplier3_plonk
snarkjs r1cs info Multiplier3_plonk/Multiplier3.r1cs

# Calculate and check witness
echo "{\"a\": 3, \"b\": 11, \"c\": 16}" > input.json
node Multiplier3_plonk/Multiplier3_js/generate_witness.js Multiplier3_plonk/Multiplier3_js/Multiplier3.wasm ./input.json ./witness.wtns
snarkjs wtns check Multiplier3_plonk/Multiplier3.r1cs witness.wtns


# Setup
snarkjs plonk setup Multiplier3_plonk/Multiplier3.r1cs powersOfTau28_hez_final_10.ptau Multiplier3_plonk/circuit_0000.zkey

# Export the verification key
snarkjs zkey export verificationkey Multiplier3_plonk/circuit_0000.zkey Multiplier3_plonk/verification_key.json

# Create the proof
snarkjs plonk prove Multiplier3_plonk/circuit_0000.zkey witness.wtns proof.json public.json

# Verify the proof
snarkjs plonk verify Multiplier3_plonk/verification_key.json public.json proof.json

cd ../..