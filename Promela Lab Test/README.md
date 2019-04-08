Assume that there are three processes belonging to three different customers of a bank that attempt to increment the balance in a public charity account. The amount of donation is fixed at Rs 1001/-. That is the three processes attempt to execute the statement 

    Balance = Balance + 1001.
 
Now, assume as a system designer you have to implement this critical section of the code using Test-and-Set function that works as follows:

    repeat
    while Test-and-Set(lock) do no-op;
    critical-section
    lock=FALSE;
    until false

Assume that Test-and-Set is invoked by the three processes as follows:

    Test-and-Set(target) 
    result := target 
    target := TRUE 
    return result

Model the above scenario in PROMELA. Implement the atomic updation to lock using the semaphores. Assume that the init process initially sets the variable target = FALSE. 
