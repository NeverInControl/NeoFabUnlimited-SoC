import struct

with open("zephyr_raw.bin", "rb") as f:
    data = f.read()

# Pad to 4-byte boundary
while len(data) % 4 != 0:
    data += b'\x00'

# Calculate Checksum (sum of 32-bit words)
words = struct.unpack("<" + "I" * (len(data) // 4), data)
checksum = sum(words) & 0xFFFFFFFF

# One's complement inversion (Bitwise NOT)
# This is what the NEORV32 bootloader actually expects
checksum = (~checksum) & 0xFFFFFFFF

# Header: Signature, Base Addr (0), Size, Checksum
header = struct.pack("<IIII", 0x214F454E, 0, len(data), checksum)

with open("zephyr_exe.bin", "wb") as f:
    f.write(header)
    f.write(data)

print(f"Generated zephyr_exe.bin: {len(data)} bytes")
