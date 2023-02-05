#include <stdio.h>

static const char* fizz = "fizz";
static const char* buzz = "buzz";

int ipow(int base, int exponent)
{
    if (exponent <= 0)
        return 1;
    if (exponent == 1)
        return base;
    int result = base;
    for (int i = 1; i < exponent; i++)
        result *= base;
    return result;
}

void print_int(int value)
{
    _Bool has_printed = 0;
    for (int i = 10; i >= 0; --i) {
        int m = ipow(10, i);
        int v = value / m;
        value -= m * v;
        if (v != 0 || has_printed) {
            fputc(v + 48, stdout);
            has_printed = 1;
        }
    }
}

void fizzbuzz(int n)
{
    if (n % 15 == 0) {
        fputs(fizz, stdout);
        fputs(buzz, stdout);
    } else if (n % 5 == 0) {
        fputs(buzz, stdout);
    } else if (n % 3 == 0) {
        fputs(fizz, stdout);
    } else {
        print_int(n);
    }
    fputc('\n', stdout);
}

int main()
{
    for (int i = 1; i <= 100; ++i)
        fizzbuzz(i);
}
