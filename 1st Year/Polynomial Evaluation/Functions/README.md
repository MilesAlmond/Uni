Simple evaluates matrix polynomials in ascending integer powers of x starting from 0 from a kxmxn array of k mxn matrices and a single nxn matrix "x". It has two inputs, the array "a" and "x". The ouput will be an mxn matrix. Note: function also works for a kxnxn array (so where m=n), giving an nxn matrix output.
Simple calls MyExpt which is a function used to calculate powers of real numbers or matrices by recursively calculating (A^2)^(n/2). It has two inputs, the number or matrix "A", and the power to which it will be raised "n". Note: n must be a positive integer or 0.
Sparse, like Simple, evaluates a matrix polynomial of k mxn matrices, however there is a third input "index" in which the powers of x used can be chosen. E.g. where k=3, index could be [4,2,7] which would calculate a_0*x^4 + a1*x^2 + a2*x^7. Like Simple, the output will be a single mxn matrix.
Faster has the exact same input and output values of Sparse however it calls a function FasterExpt which has the same input and output values of MyExpt.
FasterExpt stores values of x previously calculated and recursively calculates (A^(n/2))^2. In doing this the aim is for Faster to be a quicker version of Sparse. Note: Faster/FasterExpt only stores powers of x less than 100.