# UART Core – RTL Design in Verilog

## Overview
This project implements a complete UART (Universal Asynchronous Receiver Transmitter) core using Verilog HDL.  
The design includes a UART Transmitter (TX), UART Receiver (RX), and a Baud Rate Generator, all verified through simulation in Xilinx Vivado.

The receiver uses 16× oversampling to accurately sample asynchronous serial data.

---

## Architecture

Baud Generator → UART TX → Serial Line → UART RX

The TX converts parallel data to serial format and the RX reconstructs the received serial data back into bytes.

---

## Features
- 8-bit data format  
- 8-N-1 UART frame (8 data bits, no parity, 1 stop bit)  
- 16× oversampling in receiver  
- FSM-based transmitter and receiver  
- Modular RTL design  
- Simulation-verified  

---

## File Structure

uart_tx.v   – UART transmitter  
uart_rx.v   – UART receiver  
baud_gen.v  – Baud and sampling tick generator  
uart_top.v  – Top-level module  
uart_tb.v   – Testbench  

---

## How It Works

1. Baud generator produces timing ticks  
2. TX sends start bit, data bits, and stop bit  
3. RX detects start bit and samples bits in the middle of each bit  
4. Testbench verifies end-to-end UART communication  

---

## Simulation

The UART core was verified using Vivado behavioral simulation.  
A byte is transmitted by the TX and correctly received by the RX.

---

## Why This Project

This project demonstrates:
- RTL coding  
- FSM design  
- UART protocol understanding  
- Timing and clock management  
- Verification using testbenches  

These are core skills for VLSI and semiconductor engineering roles.

---
