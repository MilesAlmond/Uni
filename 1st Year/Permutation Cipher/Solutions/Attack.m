classdef Attack
    
    properties
        
        ciphertext %the text to be decrypted
        
        key %a 26 character permutation from A to Z
            %(stored as a row vector of the numbers 1 to 26)
        
        past %a list that stores the previous letter swaps
        
    end
    
    
    methods
        
        function a = Attack(m) %constructor method
            
            a.ciphertext = m;
            
            a.key = Key(1:26);
            
            a.past = List();
            
        end
        
        function disp(a) %a display function that prints 300 characters of
        %the current ciphertext 50 characters at a time, decrypted using 
        %the current key which is also printed
            
            a.ciphertext = decrypt(a.key,a.ciphertext);
            
            disp('Message:');
            
            disp([char(13)]);
               
            if length(a.ciphertext) >=300
            
                disp([a.ciphertext(1:50)
                      a.ciphertext(51:100)
                      a.ciphertext(101:150)
                      a.ciphertext(151:200)
                      a.ciphertext(201:250)
                      a.ciphertext(251:300)]);
            
            else
                
                z = floor(length(a.ciphertext)/3);
                %if the ciphertext is less than 300 characters long then it
                %is printed in 3 lines, each of which a third of the length
                %of the ciphertext
                disp([a.ciphertext(1:z)
                      a.ciphertext((z+1):(2*z)) 
                      a.ciphertext((2*z+1):(3*z))]);
            
            end
            
            disp([char(13)]);
            
            disp('Key:');
            
            disp([char(13)]);
            
            disp([a.key]);
            
        end
        
        function q = lettercount(a) %a function that counts the occurences
                 %of each letter in the alphabet in the original ciphertext
            
            q = zeros(1,26); %creating a row vector of zeros of length 26
            %that will store the occurence of each letter, where q(1) =
            %no. of occurences of 'A' etc.
            x = upper(a.ciphertext);
            y = x - 64; %converting from ASCII indices to the numbers 1-26
            
            for i = 1:length(a.ciphertext)
                
                if y(i)>0 && y(i)<27
                 
                    z = y(i);
                    q(z) = q(z) + 1; %looping through each character in the
                    %ciphertext and adding 1 to the relevant q(i) when the
                    %letter corresponding to i is present
                
                else
                    
                end
                
            end
            
        end
         
        function a = attack(m)
            
            x = lettercount(m);
            y = permutation(x); %arranging the lettercount values found in
            %reverse order of popularity
            z = zeros(1,26);
            
            w = 'ZQXJKVBPYGFWMUCLDRHSNIOATE'; %w is the alphabet in reverse
            %order of the most commonly used letters in the English
            %language
            Alpha = w - 64;
            
            for i = 1:26
                
                z(Alpha(i)) = y(i); %creating a vector z that assigns the
                %least commonly used letter to the letter of least
                %occurence in the lettercount function, then 2nd least and
                %so on
            
            end
                    
            m.key = Key(z); %creating a new key using this new vector v
            m.past = List();
            a = m;
            
        end 
        
        function a = sample(a) %a function that randomly prints 300
            %characters of the ciphertext, 50 characters at a time,
            %decrypted using the current key
            
            if length(a.ciphertext) > 300
            
            n = length(a.ciphertext) - 300;
            x = randi(n);
            a = decrypt(a.key,a.ciphertext(x:(x+300)));
            
            else
                
            end
            
        end
        
        function a = swap(k,a,b) %a function that swaps two letters in the
            %current key 'a' and 'b' to create a new key 
            
            k.key = swap(k.key,a,b);
            k.past = List([upper(a),upper(b)],k.past); %stores the swap
            a = k;
        
        end
        
        function a = undo(a) %a function that reverts the previous swap
            %using the past property that stores the swaps in a list
            
            if isNil(a.past) %if no swaps are currently stored, an error
                %message is printed
                 
                fprintf(2,'\nNo undo information\n');
                
            else
                
                a = swap(a,a.past.head(1),a.past.head(2));
                a.past = a.past.tail.tail;
            
            end
            
        end          
        
    end
    
end