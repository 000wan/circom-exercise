pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib-matrix/circuits/matMul.circom"; // hint: you can use more than one templates in circomlib-matrix to help you
include "../../node_modules/circomlib-matrix/circuits/transpose.circom";

template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // [bonus] insert your code here
    component T = transpose(1, n);
    T.a <== [x];

    component mul = matMul(n, n, 1);
    mul.a <== A;
    mul.b <== T.out;

    component cmp[n];
    signal res[n+1];
    res[0] <== 1;
    for (var i = 0; i < n; i++) {
        cmp[i] = IsEqual();
        cmp[i].in <== [ mul.out[i][0], b[i] ];
        res[i+1] <== res[i] * cmp[i].out;
    }
    out <== res[n];
}

component main {public [A, b]} = SystemOfEquations(3);