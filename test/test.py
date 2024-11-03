import cocotb
from cocotb.triggers import RisingEdge
import random

@cocotb.test()
async def test_alu(dut):
    """Test the ALU with a variety of operations"""

    # Reset the design
    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # Enable the design
    dut.ena.value = 1
    await RisingEdge(dut.clk)

    # Test case: Addition (Opcode 000)
    dut.ui_in.value = 0x0F  # A = 15 (binary: 00001111), B = 0
    dut.uio_in.value = 0x00  # Opcode = 000 (Addition)
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == 15, f"Addition failed: {dut.uo_out.value} != 15"

    # Test case: Subtraction (Opcode 001)
    dut.ui_in.value = 0x12  # A = 2 (binary: 0010), B = 1 (binary: 0001)
    dut.uio_in.value = 0x01  # Opcode = 001 (Subtraction)
    await RisingEdge(dut.clk)
    assert dut.uo_out.value == 1, f"Subtraction failed: {dut.uo_out.value} != 1"

    # Add more test cases as needed...

    # Print success message
    cocotb.log.info("All test cases passed!")


