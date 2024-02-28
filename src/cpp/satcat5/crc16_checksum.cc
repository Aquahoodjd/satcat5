//////////////////////////////////////////////////////////////////////////
// Copyright 2024 The Aerospace Corporation.
// This file is a part of SatCat5, licensed under CERN-OHL-W v2 or later.
//////////////////////////////////////////////////////////////////////////

#include <satcat5/crc16_checksum.h>

using satcat5::crc16::KermitRx;
using satcat5::crc16::KermitTx;
using satcat5::crc16::XmodemRx;
using satcat5::crc16::XmodemTx;

// Set default table size.
#ifndef SATCAT5_CRC_TABLE_BITS
#define SATCAT5_CRC_TABLE_BITS 8
#endif

// Tables for nybble-by-nybble CRC updates (32 bytes each)
// (See "sim/python/crc_table.py" for table-generator logic.)
#if SATCAT5_CRC_TABLE_BITS == 4
static const u16 TABLE_KERMIT[16] = {
    0x0000, 0x1081, 0x2102, 0x3183, 0x4204, 0x5285, 0x6306, 0x7387,
    0x8408, 0x9489, 0xA50A, 0xB58B, 0xC60C, 0xD68D, 0xE70E, 0xF78F,
};

static const u16 TABLE_XMODEM[16] = {
    0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50A5, 0x60C6, 0x70E7,
    0x8108, 0x9129, 0xA14A, 0xB16B, 0xC18C, 0xD1AD, 0xE1CE, 0xF1EF,
};

static inline void kermit_update(u16& crc, u8 next)
{
    u16 next1 = next >> 0;                      // First nybble
    u16 next2 = next >> 4;                      // Second nybble
    u8 index1 = (crc ^ next1) & 0x0F;           // Table index
    crc = (crc >> 4) ^ TABLE_KERMIT[index1];    // XOR with table
    u8 index2 = (crc ^ next2) & 0x0F;           // Table index
    crc = (crc >> 4) ^ TABLE_KERMIT[index2];    // XOR with table
}

static inline void xmodem_update(u16& crc, u8 next)
{
    u16 next1 = next >> 4;                      // First nybble
    u16 next2 = next >> 0;                      // Second nybble
    u8 index1 = ((crc >> 12) ^ next1) & 0x0Ful; // Table index
    crc = (crc << 4) ^ TABLE_XMODEM[index1];    // XOR with table
    u8 index2 = ((crc >> 12) ^ next2) & 0x0Ful; // Table index
    crc = (crc << 4) ^ TABLE_XMODEM[index2];    // XOR with table
}

inline u16 kermit_format(u16 crc)
{
    return __builtin_bswap16(crc);
}

inline u16 xmodem_format(u16 crc)
{
    return crc;
}
#endif  // SATCAT5_CRC_TABLE_BITS == 4

// Table for byte-by-byte CRC updates (512 bytes each)
// (See "sim/python/crc_table.py" for table-generator logic.)
#if SATCAT5_CRC_TABLE_BITS == 8
static const u16 TABLE_KERMIT[256] = {
    0x0000, 0x1189, 0x2312, 0x329B, 0x4624, 0x57AD, 0x6536, 0x74BF,
    0x8C48, 0x9DC1, 0xAF5A, 0xBED3, 0xCA6C, 0xDBE5, 0xE97E, 0xF8F7,
    0x1081, 0x0108, 0x3393, 0x221A, 0x56A5, 0x472C, 0x75B7, 0x643E,
    0x9CC9, 0x8D40, 0xBFDB, 0xAE52, 0xDAED, 0xCB64, 0xF9FF, 0xE876,
    0x2102, 0x308B, 0x0210, 0x1399, 0x6726, 0x76AF, 0x4434, 0x55BD,
    0xAD4A, 0xBCC3, 0x8E58, 0x9FD1, 0xEB6E, 0xFAE7, 0xC87C, 0xD9F5,
    0x3183, 0x200A, 0x1291, 0x0318, 0x77A7, 0x662E, 0x54B5, 0x453C,
    0xBDCB, 0xAC42, 0x9ED9, 0x8F50, 0xFBEF, 0xEA66, 0xD8FD, 0xC974,
    0x4204, 0x538D, 0x6116, 0x709F, 0x0420, 0x15A9, 0x2732, 0x36BB,
    0xCE4C, 0xDFC5, 0xED5E, 0xFCD7, 0x8868, 0x99E1, 0xAB7A, 0xBAF3,
    0x5285, 0x430C, 0x7197, 0x601E, 0x14A1, 0x0528, 0x37B3, 0x263A,
    0xDECD, 0xCF44, 0xFDDF, 0xEC56, 0x98E9, 0x8960, 0xBBFB, 0xAA72,
    0x6306, 0x728F, 0x4014, 0x519D, 0x2522, 0x34AB, 0x0630, 0x17B9,
    0xEF4E, 0xFEC7, 0xCC5C, 0xDDD5, 0xA96A, 0xB8E3, 0x8A78, 0x9BF1,
    0x7387, 0x620E, 0x5095, 0x411C, 0x35A3, 0x242A, 0x16B1, 0x0738,
    0xFFCF, 0xEE46, 0xDCDD, 0xCD54, 0xB9EB, 0xA862, 0x9AF9, 0x8B70,
    0x8408, 0x9581, 0xA71A, 0xB693, 0xC22C, 0xD3A5, 0xE13E, 0xF0B7,
    0x0840, 0x19C9, 0x2B52, 0x3ADB, 0x4E64, 0x5FED, 0x6D76, 0x7CFF,
    0x9489, 0x8500, 0xB79B, 0xA612, 0xD2AD, 0xC324, 0xF1BF, 0xE036,
    0x18C1, 0x0948, 0x3BD3, 0x2A5A, 0x5EE5, 0x4F6C, 0x7DF7, 0x6C7E,
    0xA50A, 0xB483, 0x8618, 0x9791, 0xE32E, 0xF2A7, 0xC03C, 0xD1B5,
    0x2942, 0x38CB, 0x0A50, 0x1BD9, 0x6F66, 0x7EEF, 0x4C74, 0x5DFD,
    0xB58B, 0xA402, 0x9699, 0x8710, 0xF3AF, 0xE226, 0xD0BD, 0xC134,
    0x39C3, 0x284A, 0x1AD1, 0x0B58, 0x7FE7, 0x6E6E, 0x5CF5, 0x4D7C,
    0xC60C, 0xD785, 0xE51E, 0xF497, 0x8028, 0x91A1, 0xA33A, 0xB2B3,
    0x4A44, 0x5BCD, 0x6956, 0x78DF, 0x0C60, 0x1DE9, 0x2F72, 0x3EFB,
    0xD68D, 0xC704, 0xF59F, 0xE416, 0x90A9, 0x8120, 0xB3BB, 0xA232,
    0x5AC5, 0x4B4C, 0x79D7, 0x685E, 0x1CE1, 0x0D68, 0x3FF3, 0x2E7A,
    0xE70E, 0xF687, 0xC41C, 0xD595, 0xA12A, 0xB0A3, 0x8238, 0x93B1,
    0x6B46, 0x7ACF, 0x4854, 0x59DD, 0x2D62, 0x3CEB, 0x0E70, 0x1FF9,
    0xF78F, 0xE606, 0xD49D, 0xC514, 0xB1AB, 0xA022, 0x92B9, 0x8330,
    0x7BC7, 0x6A4E, 0x58D5, 0x495C, 0x3DE3, 0x2C6A, 0x1EF1, 0x0F78,
};

static const u16 TABLE_XMODEM[256] = {
    0x0000, 0x2110, 0x4220, 0x6330, 0x8440, 0xA550, 0xC660, 0xE770,
    0x0881, 0x2991, 0x4AA1, 0x6BB1, 0x8CC1, 0xADD1, 0xCEE1, 0xEFF1,
    0x3112, 0x1002, 0x7332, 0x5222, 0xB552, 0x9442, 0xF772, 0xD662,
    0x3993, 0x1883, 0x7BB3, 0x5AA3, 0xBDD3, 0x9CC3, 0xFFF3, 0xDEE3,
    0x6224, 0x4334, 0x2004, 0x0114, 0xE664, 0xC774, 0xA444, 0x8554,
    0x6AA5, 0x4BB5, 0x2885, 0x0995, 0xEEE5, 0xCFF5, 0xACC5, 0x8DD5,
    0x5336, 0x7226, 0x1116, 0x3006, 0xD776, 0xF666, 0x9556, 0xB446,
    0x5BB7, 0x7AA7, 0x1997, 0x3887, 0xDFF7, 0xFEE7, 0x9DD7, 0xBCC7,
    0xC448, 0xE558, 0x8668, 0xA778, 0x4008, 0x6118, 0x0228, 0x2338,
    0xCCC9, 0xEDD9, 0x8EE9, 0xAFF9, 0x4889, 0x6999, 0x0AA9, 0x2BB9,
    0xF55A, 0xD44A, 0xB77A, 0x966A, 0x711A, 0x500A, 0x333A, 0x122A,
    0xFDDB, 0xDCCB, 0xBFFB, 0x9EEB, 0x799B, 0x588B, 0x3BBB, 0x1AAB,
    0xA66C, 0x877C, 0xE44C, 0xC55C, 0x222C, 0x033C, 0x600C, 0x411C,
    0xAEED, 0x8FFD, 0xECCD, 0xCDDD, 0x2AAD, 0x0BBD, 0x688D, 0x499D,
    0x977E, 0xB66E, 0xD55E, 0xF44E, 0x133E, 0x322E, 0x511E, 0x700E,
    0x9FFF, 0xBEEF, 0xDDDF, 0xFCCF, 0x1BBF, 0x3AAF, 0x599F, 0x788F,
    0x8891, 0xA981, 0xCAB1, 0xEBA1, 0x0CD1, 0x2DC1, 0x4EF1, 0x6FE1,
    0x8010, 0xA100, 0xC230, 0xE320, 0x0450, 0x2540, 0x4670, 0x6760,
    0xB983, 0x9893, 0xFBA3, 0xDAB3, 0x3DC3, 0x1CD3, 0x7FE3, 0x5EF3,
    0xB102, 0x9012, 0xF322, 0xD232, 0x3542, 0x1452, 0x7762, 0x5672,
    0xEAB5, 0xCBA5, 0xA895, 0x8985, 0x6EF5, 0x4FE5, 0x2CD5, 0x0DC5,
    0xE234, 0xC324, 0xA014, 0x8104, 0x6674, 0x4764, 0x2454, 0x0544,
    0xDBA7, 0xFAB7, 0x9987, 0xB897, 0x5FE7, 0x7EF7, 0x1DC7, 0x3CD7,
    0xD326, 0xF236, 0x9106, 0xB016, 0x5766, 0x7676, 0x1546, 0x3456,
    0x4CD9, 0x6DC9, 0x0EF9, 0x2FE9, 0xC899, 0xE989, 0x8AB9, 0xABA9,
    0x4458, 0x6548, 0x0678, 0x2768, 0xC018, 0xE108, 0x8238, 0xA328,
    0x7DCB, 0x5CDB, 0x3FEB, 0x1EFB, 0xF98B, 0xD89B, 0xBBAB, 0x9ABB,
    0x754A, 0x545A, 0x376A, 0x167A, 0xF10A, 0xD01A, 0xB32A, 0x923A,
    0x2EFD, 0x0FED, 0x6CDD, 0x4DCD, 0xAABD, 0x8BAD, 0xE89D, 0xC98D,
    0x267C, 0x076C, 0x645C, 0x454C, 0xA23C, 0x832C, 0xE01C, 0xC10C,
    0x1FEF, 0x3EFF, 0x5DCF, 0x7CDF, 0x9BAF, 0xBABF, 0xD98F, 0xF89F,
    0x176E, 0x367E, 0x554E, 0x745E, 0x932E, 0xB23E, 0xD10E, 0xF01E,
};

static inline void kermit_update(u16& crc, u8 next)
{
    u8 index = (crc ^ (u16)next) & 0xFFul;      // Table index
    crc = (crc >> 8) ^ TABLE_KERMIT[index];     // XOR with table
}

static inline void xmodem_update(u16& crc, u8 next)
{
    u8 index = (crc  ^ (u16)next) & 0xFFul;     // Table index
    crc = (crc >> 8) ^ TABLE_XMODEM[index];     // XOR with table
}

inline u16 kermit_format(u16 crc)
{
    return __builtin_bswap16(crc);
}

inline u16 xmodem_format(u16 crc)
{
    return __builtin_bswap16(crc);
}

#endif  // SATCAT5_CRC_TABLE_BITS == 8

u16 satcat5::crc16::kermit(unsigned nbytes, const void* data)
{
    // Byte-by-byte CRC16 calculation.
    const u8* data8 = (const u8*)data;
    u16 crc = 0;
    for (unsigned a = 0 ; a < nbytes ; ++a)
        kermit_update(crc, data8[a]);
    return kermit_format(crc);
}

u16 satcat5::crc16::xmodem(unsigned nbytes, const void* data)
{
    // Byte-by-byte CRC16 calculation.
    const u8* data8 = (const u8*)data;
    u16 crc = 0;
    for (unsigned a = 0 ; a < nbytes ; ++a)
        xmodem_update(crc, data8[a]);
    return xmodem_format(crc);
}

KermitTx::KermitTx(satcat5::io::Writeable* dst, u16 init)
    : satcat5::io::ChecksumTx<u16,2>(dst, init)
{
    // Nothing else to initialize
}

bool KermitTx::write_finalize()
{
    u16 fcs = kermit_format(m_chk) ^ m_init;
    m_dst->write_u16(fcs);      // Append FCS
    return chk_finalize() && m_dst->write_finalize();
}

void KermitTx::write_next(u8 data)
{
    kermit_update(m_chk, data); // Update internal state
    m_dst->write_u8(data);      // Forward new data
}

KermitRx::KermitRx(satcat5::io::Writeable* dst, u16 init)
    : satcat5::io::ChecksumRx<u16,2>(dst, init)
{
    // Nothing else to initialize
}

bool KermitRx::write_finalize()
{
    return sreg_match(kermit_format(m_chk) ^ m_init);
}

void KermitRx::write_next(u8 data)
{
    if (sreg_push(data)) kermit_update(m_chk, data);
}

XmodemTx::XmodemTx(satcat5::io::Writeable* dst, u16 init)
    : satcat5::io::ChecksumTx<u16,2>(dst, init)
{
    // Nothing else to initialize
}

bool XmodemTx::write_finalize()
{
    u16 fcs = xmodem_format(m_chk) ^ m_init;
    m_dst->write_u16(fcs);              // Append formatted FCS
    return chk_finalize() && m_dst->write_finalize();
}

void XmodemTx::write_next(u8 data)
{
    xmodem_update(m_chk, data);         // Update internal state
    m_dst->write_u8(data);              // Forward new data
}

XmodemRx::XmodemRx(satcat5::io::Writeable* dst, u16 init)
    : satcat5::io::ChecksumRx<u16,2>(dst, init)
{
    // Nothing else to initialize
}

bool XmodemRx::write_finalize()
{
    return sreg_match(xmodem_format(m_chk) ^ m_init);
}

void XmodemRx::write_next(u8 data)
{
    if (sreg_push(data)) xmodem_update(m_chk, data);
}