classdef Key
    
    
    
    properties
        
        perm %a 26 character permutation from A to Z
             %(stored as a row vector of the numbers 1 to 26)
    
    end
    
    
    
    methods
      
        
        function a = Key(p) %constructor method
            
            if nargin == 0 %if 'Key' has no input, a random alphabet
                %permutation is created
                
                a.perm = randperm(26);
            
            elseif upper(p)>64 %if p(i) are letters of the alphabet then
                %they are transformed into their respective numbers 1-26
                
                a.perm = upper(p) - 64;
                
            else
                
                a.perm = p;
            
            end
        
        end
        
        
        function disp(a) %a display function that takes the numbers 1 to 26
            %in a.perm and displays them as the uppercase letters A to Z
            
            disp([char((a.perm)+64)]);
        
        end
        
        
        function a = mtimes(l,m) %a function that gives the composition of
            %two keys
               
            x = m.perm;
            y = m.perm;
                
            for i = 1:26
                
                x(i) = l.perm(y(i));
                
            end
            
            a = Key(x);
        
        end
        
        
        function a = invert(k) %a function that inverts the current key k
            %e.g. if k.perm(x) = y then k.invert.perm(y) = x
           
            x = k.perm; %assigns k.perm twice as y is constanly being
            %updated but need a variable x with the initial key
            y = k.perm;
            
            for i = 1:26
                
                z = x(i);
                y(z) = i;
            
            end
            
            a = Key(y);
        
        end
        
        
        function a = encrypt(k,m) %a function that encrypts any message m
            %with the current key permutation
            
            z = upper(m);
            b = upper(z-64);
            
            for i = 1:length(m)
                
                if b(i)>0 && b(i)<27
               
                    b(i) = k.perm(b(i));
                
                else
                    
                end
                
            end
         
            a = char(b+64);
        
        end
        
        
        function a = decrypt(k,m) %a function that decrypts any message m
            %by taking the inverse of a given key k and encrypting it
            
            z = invert(k);
            a = encrypt(z,m);
        
        end
        
        function a = swap(k,a,b) %a function that swaps two letters in the
            %current key 'a' and 'b' to create a new key
            
            c = upper(a) - 64;
            d = upper(b) - 64;
            p = k.perm(c);
            q = k.perm(d);
            
            k.perm(c) = q;
            k.perm(d) = p;
            
            a = k;         
               
        end
        
    end
    
end