function sequence = Zadoff_Chu(L, q, k)
% L is the sequence length, 
% q an integer, 
% k is a coprime number with L

coprime = gcd(L,k);

if coprime == 1
    n = 0:L-1;
    num = pi.*k.*n.*(n+1+2.*q);
    sequence = exp(-1i*num./L);
else
    errID = 'MYFUN:BadNumbers';
    msg = 'L and k are not coprime numbers.';
    baseException = MException(errID,msg);
    throw(baseException)
end

