# Crackme

Now we are studying different exploits and security problems, so our task is for it.
We are currently working in x86 assembler and doing the task only through .com files, without .asm.
I have exchanged crackme programs with my classmate to hack each other.
We received only .com files, so we had to work in byte world and use disassembler.
Here are two exploits I found in his program and a patch used to change one byte to grant access without any particular input.

1. __Simple exploit__
Input buffer overflow, no check of input size. Therefore, input erases real password and input checks our new reference password.
>Input: "1234567812345678"

2. __Hard exploit__
Before input buffer located difference between offsets of input and reference password.
If we change it to zero, input buffer will check itself.
>Input: backspace + enter

3. __Patch__
In program after password is checked, AX register is being changed, depended on the check result. If password is wrong, `AX = 0`.
Output depends on AX value. If `AX == 0`, access is denied.
So we want to change one byte after check and replace `AX = 0` to `AX = 1`.
For that, compile and run patch.cpp file. Run PASSWORD_P.COM and use any input, access will be granted.
>Input: any input
