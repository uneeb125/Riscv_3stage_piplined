# Assuming UART address is mapped to 0x80000000
li a0, 0x80000000   # Load UART address into a0
lw a1, 0(a0)        # Load the value from UART address into a1

# Check if data has been received
li t0, 0            # Load 0 into temporary register t0
beq a1, t0, no_data_received   # Branch if data is equal to 0
# If data is not equal to 0, UART receiver is working and data has been received

# Data not received
j end

no_data_received:
# Data received, do something here
# For example, print a message or process the received data
# Here, you might want to write your UART transmit code to send a message indicating successful reception

# For demonstration, let's print a message indicating no data received
li a0, 0x80000000   # Load UART address into a0
li a1, 'N'          # Load ASCII character 'N' into a1
sb a1, 0(a0)        # Store the character into UART data register to transmit

end:
# End of code



 
