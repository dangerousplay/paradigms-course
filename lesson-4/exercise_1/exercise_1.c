#include <stdio.h>

int X = 0;
int Y;

void fie() {
    X++;
}

void foo() {
    X++;
    fie();
}

int main() {
    scanf("%d", &Y);

    if(Y > 0) {
        int X = 5;
        foo();
    } else {
        foo();
    }

    printf("%d", X);

    return 0;
}
