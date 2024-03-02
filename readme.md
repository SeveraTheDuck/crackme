<h1>Crackme</h1>
I have exchanged crackme programs with my classmate to hack each other.<br>
We received only .com files, so we had to work in byte world and use disassembler.<br>
Here are two exploits I found in his program and a patch used to change one byte
to grant access without any input.<br>

<ol>
        <li>
        (Simple exploit) Input buffer overflow, no check of input size. Therefore, input erases real password and input checks our new reference password.<br>
        Input: "1234567812345678"
        </li>
        <li>
        (Hard exploit) Before input buffer located difference between offsets of input and reference password.<br>
        If we change it to zero, input buffer will check itself.<br>
        Input: backspace + enter
        </li>
        <li>
        (Patch) In program after password is checked, AX register is being changed, depended on the check result. If password is wrong, AX = 0. <br>
        Output depends on AX value. If AX == 0, access is denied.<br>
        So we want to change one byte after check and replace AX = 0 to AX = 1.<br>
        For that, compile and run patch.cpp. Run PASSWORD_P.COM and use any input, access will be granted.
        </li>
</ol>
