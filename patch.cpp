#include <stdio.h>
#include <assert.h>

int main ()
{
        FILE* const fp = fopen ("PASSWORD_P.COM", "r+");
        assert (fp);

        unsigned char replace = 1;

        fseek  (fp, 0x93, SEEK_SET);
        fwrite (&replace, sizeof (char), 1, fp);

        fclose (fp);
}
