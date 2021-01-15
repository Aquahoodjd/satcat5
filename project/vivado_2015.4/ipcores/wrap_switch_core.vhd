--------------------------------------------------------------------------
-- Copyright 2019 The Aerospace Corporation
--
-- This file is part of SatCat5.
--
-- SatCat5 is free software: you can redistribute it and/or modify it under
-- the terms of the GNU Lesser General Public License as published by the
-- Free Software Foundation, either version 3 of the License, or (at your
-- option) any later version.
--
-- SatCat5 is distributed in the hope that it will be useful, but WITHOUT
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
-- FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
-- License for more details.
--
-- You should have received a copy of the GNU Lesser General Public License
-- along with SatCat5.  If not, see <https://www.gnu.org/licenses/>.
--------------------------------------------------------------------------
--
-- Port-type wrapper for "switch_core"
--
-- Xilinx IP-cores can only use simple std_logic and std_logic_vector types.
-- This shim provides that conversion.
--
-- IMPORTANT NOTE: This script takes a LONG time to run in GUI mode, and can
-- even run out of memory.  It should always be run from the TCL console.
--

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     work.common_functions.all;
use     work.switch_types.all;

entity wrap_switch_core is
    generic (
    STATS_AXI_EN    : boolean;  -- Enable traffic statistics over AXI-lite?
    AXI_ADDR_WIDTH  : natural;  -- AXI-Lite address width, if enabled.
    STATS_UART_EN   : boolean;  -- Enable traffic statistics over UART?
    STATS_UART_BAUD : integer;  -- Baud rate for UART, if enabled.
    CORE_CLK_HZ     : integer;  -- Clock frequency for CORE_CLK
    SUPPORT_PAUSE   : boolean;  -- Support or ignore PAUSE frames?
    ALLOW_JUMBO     : boolean;  -- Allow jumbo frames? (Size up to 9038 bytes)
    ALLOW_RUNT      : boolean;  -- Allow runt frames? (Size < 64 bytes)
    PORT_COUNT      : integer;  -- Total number of Ethernet ports
    DATAPATH_BYTES  : integer;  -- Width of shared pipeline
    IBUF_KBYTES     : integer;  -- Input buffer size (kilobytes)
    OBUF_KBYTES     : integer;  -- Output buffer size (kilobytes)
    MAC_TABLE_SIZE  : integer;  -- Max stored MAC addresses
    SCRUB_TIMEOUT   : integer); -- Timeout for stale MAC entries
    port (
    -- Up to 32 network ports, enabled/hidden based on PORT_COUNT.
    p00_rx_clk      : in  std_logic;
    p00_rx_data     : in  std_logic_vector(7 downto 0);
    p00_rx_last     : in  std_logic;
    p00_rx_write    : in  std_logic;
    p00_rx_error    : in  std_logic;
    p00_rx_rate     : in  std_logic_vector(15 downto 0);
    p00_rx_reset    : in  std_logic;
    p00_tx_clk      : in  std_logic;
    p00_tx_data     : out std_logic_vector(7 downto 0);
    p00_tx_last     : out std_logic;
    p00_tx_valid    : out std_logic;
    p00_tx_ready    : in  std_logic;
    p00_tx_error    : in  std_logic;
    p00_tx_reset    : in  std_logic;

    p01_rx_clk      : in  std_logic;
    p01_rx_data     : in  std_logic_vector(7 downto 0);
    p01_rx_last     : in  std_logic;
    p01_rx_write    : in  std_logic;
    p01_rx_error    : in  std_logic;
    p01_rx_rate     : in  std_logic_vector(15 downto 0);
    p01_rx_reset    : in  std_logic;
    p01_tx_clk      : in  std_logic;
    p01_tx_data     : out std_logic_vector(7 downto 0);
    p01_tx_last     : out std_logic;
    p01_tx_valid    : out std_logic;
    p01_tx_ready    : in  std_logic;
    p01_tx_error    : in  std_logic;
    p01_tx_reset    : in  std_logic;

    p02_rx_clk      : in  std_logic;
    p02_rx_data     : in  std_logic_vector(7 downto 0);
    p02_rx_last     : in  std_logic;
    p02_rx_write    : in  std_logic;
    p02_rx_error    : in  std_logic;
    p02_rx_rate     : in  std_logic_vector(15 downto 0);
    p02_rx_reset    : in  std_logic;
    p02_tx_clk      : in  std_logic;
    p02_tx_data     : out std_logic_vector(7 downto 0);
    p02_tx_last     : out std_logic;
    p02_tx_valid    : out std_logic;
    p02_tx_ready    : in  std_logic;
    p02_tx_error    : in  std_logic;
    p02_tx_reset    : in  std_logic;

    p03_rx_clk      : in  std_logic;
    p03_rx_data     : in  std_logic_vector(7 downto 0);
    p03_rx_last     : in  std_logic;
    p03_rx_write    : in  std_logic;
    p03_rx_error    : in  std_logic;
    p03_rx_rate     : in  std_logic_vector(15 downto 0);
    p03_rx_reset    : in  std_logic;
    p03_tx_clk      : in  std_logic;
    p03_tx_data     : out std_logic_vector(7 downto 0);
    p03_tx_last     : out std_logic;
    p03_tx_valid    : out std_logic;
    p03_tx_ready    : in  std_logic;
    p03_tx_error    : in  std_logic;
    p03_tx_reset    : in  std_logic;

    p04_rx_clk      : in  std_logic;
    p04_rx_data     : in  std_logic_vector(7 downto 0);
    p04_rx_last     : in  std_logic;
    p04_rx_write    : in  std_logic;
    p04_rx_error    : in  std_logic;
    p04_rx_rate     : in  std_logic_vector(15 downto 0);
    p04_rx_reset    : in  std_logic;
    p04_tx_clk      : in  std_logic;
    p04_tx_data     : out std_logic_vector(7 downto 0);
    p04_tx_last     : out std_logic;
    p04_tx_valid    : out std_logic;
    p04_tx_ready    : in  std_logic;
    p04_tx_error    : in  std_logic;
    p04_tx_reset    : in  std_logic;

    p05_rx_clk      : in  std_logic;
    p05_rx_data     : in  std_logic_vector(7 downto 0);
    p05_rx_last     : in  std_logic;
    p05_rx_write    : in  std_logic;
    p05_rx_error    : in  std_logic;
    p05_rx_rate     : in  std_logic_vector(15 downto 0);
    p05_rx_reset    : in  std_logic;
    p05_tx_clk      : in  std_logic;
    p05_tx_data     : out std_logic_vector(7 downto 0);
    p05_tx_last     : out std_logic;
    p05_tx_valid    : out std_logic;
    p05_tx_ready    : in  std_logic;
    p05_tx_error    : in  std_logic;
    p05_tx_reset    : in  std_logic;

    p06_rx_clk      : in  std_logic;
    p06_rx_data     : in  std_logic_vector(7 downto 0);
    p06_rx_last     : in  std_logic;
    p06_rx_write    : in  std_logic;
    p06_rx_error    : in  std_logic;
    p06_rx_rate     : in  std_logic_vector(15 downto 0);
    p06_rx_reset    : in  std_logic;
    p06_tx_clk      : in  std_logic;
    p06_tx_data     : out std_logic_vector(7 downto 0);
    p06_tx_last     : out std_logic;
    p06_tx_valid    : out std_logic;
    p06_tx_ready    : in  std_logic;
    p06_tx_error    : in  std_logic;
    p06_tx_reset    : in  std_logic;

    p07_rx_clk      : in  std_logic;
    p07_rx_data     : in  std_logic_vector(7 downto 0);
    p07_rx_last     : in  std_logic;
    p07_rx_write    : in  std_logic;
    p07_rx_error    : in  std_logic;
    p07_rx_rate     : in  std_logic_vector(15 downto 0);
    p07_rx_reset    : in  std_logic;
    p07_tx_clk      : in  std_logic;
    p07_tx_data     : out std_logic_vector(7 downto 0);
    p07_tx_last     : out std_logic;
    p07_tx_valid    : out std_logic;
    p07_tx_ready    : in  std_logic;
    p07_tx_error    : in  std_logic;
    p07_tx_reset    : in  std_logic;

    p08_rx_clk      : in  std_logic;
    p08_rx_data     : in  std_logic_vector(7 downto 0);
    p08_rx_last     : in  std_logic;
    p08_rx_write    : in  std_logic;
    p08_rx_error    : in  std_logic;
    p08_rx_rate     : in  std_logic_vector(15 downto 0);
    p08_rx_reset    : in  std_logic;
    p08_tx_clk      : in  std_logic;
    p08_tx_data     : out std_logic_vector(7 downto 0);
    p08_tx_last     : out std_logic;
    p08_tx_valid    : out std_logic;
    p08_tx_ready    : in  std_logic;
    p08_tx_error    : in  std_logic;
    p08_tx_reset    : in  std_logic;

    p09_rx_clk      : in  std_logic;
    p09_rx_data     : in  std_logic_vector(7 downto 0);
    p09_rx_last     : in  std_logic;
    p09_rx_write    : in  std_logic;
    p09_rx_error    : in  std_logic;
    p09_rx_rate     : in  std_logic_vector(15 downto 0);
    p09_rx_reset    : in  std_logic;
    p09_tx_clk      : in  std_logic;
    p09_tx_data     : out std_logic_vector(7 downto 0);
    p09_tx_last     : out std_logic;
    p09_tx_valid    : out std_logic;
    p09_tx_ready    : in  std_logic;
    p09_tx_error    : in  std_logic;
    p09_tx_reset    : in  std_logic;

    p10_rx_clk      : in  std_logic;
    p10_rx_data     : in  std_logic_vector(7 downto 0);
    p10_rx_last     : in  std_logic;
    p10_rx_write    : in  std_logic;
    p10_rx_error    : in  std_logic;
    p10_rx_rate     : in  std_logic_vector(15 downto 0);
    p10_rx_reset    : in  std_logic;
    p10_tx_clk      : in  std_logic;
    p10_tx_data     : out std_logic_vector(7 downto 0);
    p10_tx_last     : out std_logic;
    p10_tx_valid    : out std_logic;
    p10_tx_ready    : in  std_logic;
    p10_tx_error    : in  std_logic;
    p10_tx_reset    : in  std_logic;

    p11_rx_clk      : in  std_logic;
    p11_rx_data     : in  std_logic_vector(7 downto 0);
    p11_rx_last     : in  std_logic;
    p11_rx_write    : in  std_logic;
    p11_rx_error    : in  std_logic;
    p11_rx_rate     : in  std_logic_vector(15 downto 0);
    p11_rx_reset    : in  std_logic;
    p11_tx_clk      : in  std_logic;
    p11_tx_data     : out std_logic_vector(7 downto 0);
    p11_tx_last     : out std_logic;
    p11_tx_valid    : out std_logic;
    p11_tx_ready    : in  std_logic;
    p11_tx_error    : in  std_logic;
    p11_tx_reset    : in  std_logic;

    p12_rx_clk      : in  std_logic;
    p12_rx_data     : in  std_logic_vector(7 downto 0);
    p12_rx_last     : in  std_logic;
    p12_rx_write    : in  std_logic;
    p12_rx_error    : in  std_logic;
    p12_rx_rate     : in  std_logic_vector(15 downto 0);
    p12_rx_reset    : in  std_logic;
    p12_tx_clk      : in  std_logic;
    p12_tx_data     : out std_logic_vector(7 downto 0);
    p12_tx_last     : out std_logic;
    p12_tx_valid    : out std_logic;
    p12_tx_ready    : in  std_logic;
    p12_tx_error    : in  std_logic;
    p12_tx_reset    : in  std_logic;

    p13_rx_clk      : in  std_logic;
    p13_rx_data     : in  std_logic_vector(7 downto 0);
    p13_rx_last     : in  std_logic;
    p13_rx_write    : in  std_logic;
    p13_rx_error    : in  std_logic;
    p13_rx_rate     : in  std_logic_vector(15 downto 0);
    p13_rx_reset    : in  std_logic;
    p13_tx_clk      : in  std_logic;
    p13_tx_data     : out std_logic_vector(7 downto 0);
    p13_tx_last     : out std_logic;
    p13_tx_valid    : out std_logic;
    p13_tx_ready    : in  std_logic;
    p13_tx_error    : in  std_logic;
    p13_tx_reset    : in  std_logic;

    p14_rx_clk      : in  std_logic;
    p14_rx_data     : in  std_logic_vector(7 downto 0);
    p14_rx_last     : in  std_logic;
    p14_rx_write    : in  std_logic;
    p14_rx_error    : in  std_logic;
    p14_rx_rate     : in  std_logic_vector(15 downto 0);
    p14_rx_reset    : in  std_logic;
    p14_tx_clk      : in  std_logic;
    p14_tx_data     : out std_logic_vector(7 downto 0);
    p14_tx_last     : out std_logic;
    p14_tx_valid    : out std_logic;
    p14_tx_ready    : in  std_logic;
    p14_tx_error    : in  std_logic;
    p14_tx_reset    : in  std_logic;

    p15_rx_clk      : in  std_logic;
    p15_rx_data     : in  std_logic_vector(7 downto 0);
    p15_rx_last     : in  std_logic;
    p15_rx_write    : in  std_logic;
    p15_rx_error    : in  std_logic;
    p15_rx_rate     : in  std_logic_vector(15 downto 0);
    p15_rx_reset    : in  std_logic;
    p15_tx_clk      : in  std_logic;
    p15_tx_data     : out std_logic_vector(7 downto 0);
    p15_tx_last     : out std_logic;
    p15_tx_valid    : out std_logic;
    p15_tx_ready    : in  std_logic;
    p15_tx_error    : in  std_logic;
    p15_tx_reset    : in  std_logic;

    p16_rx_clk      : in  std_logic;
    p16_rx_data     : in  std_logic_vector(7 downto 0);
    p16_rx_last     : in  std_logic;
    p16_rx_write    : in  std_logic;
    p16_rx_error    : in  std_logic;
    p16_rx_rate     : in  std_logic_vector(15 downto 0);
    p16_rx_reset    : in  std_logic;
    p16_tx_clk      : in  std_logic;
    p16_tx_data     : out std_logic_vector(7 downto 0);
    p16_tx_last     : out std_logic;
    p16_tx_valid    : out std_logic;
    p16_tx_ready    : in  std_logic;
    p16_tx_error    : in  std_logic;
    p16_tx_reset    : in  std_logic;

    p17_rx_clk      : in  std_logic;
    p17_rx_data     : in  std_logic_vector(7 downto 0);
    p17_rx_last     : in  std_logic;
    p17_rx_write    : in  std_logic;
    p17_rx_error    : in  std_logic;
    p17_rx_rate     : in  std_logic_vector(15 downto 0);
    p17_rx_reset    : in  std_logic;
    p17_tx_clk      : in  std_logic;
    p17_tx_data     : out std_logic_vector(7 downto 0);
    p17_tx_last     : out std_logic;
    p17_tx_valid    : out std_logic;
    p17_tx_ready    : in  std_logic;
    p17_tx_error    : in  std_logic;
    p17_tx_reset    : in  std_logic;

    p18_rx_clk      : in  std_logic;
    p18_rx_data     : in  std_logic_vector(7 downto 0);
    p18_rx_last     : in  std_logic;
    p18_rx_write    : in  std_logic;
    p18_rx_error    : in  std_logic;
    p18_rx_rate     : in  std_logic_vector(15 downto 0);
    p18_rx_reset    : in  std_logic;
    p18_tx_clk      : in  std_logic;
    p18_tx_data     : out std_logic_vector(7 downto 0);
    p18_tx_last     : out std_logic;
    p18_tx_valid    : out std_logic;
    p18_tx_ready    : in  std_logic;
    p18_tx_error    : in  std_logic;
    p18_tx_reset    : in  std_logic;

    p19_rx_clk      : in  std_logic;
    p19_rx_data     : in  std_logic_vector(7 downto 0);
    p19_rx_last     : in  std_logic;
    p19_rx_write    : in  std_logic;
    p19_rx_error    : in  std_logic;
    p19_rx_rate     : in  std_logic_vector(15 downto 0);
    p19_rx_reset    : in  std_logic;
    p19_tx_clk      : in  std_logic;
    p19_tx_data     : out std_logic_vector(7 downto 0);
    p19_tx_last     : out std_logic;
    p19_tx_valid    : out std_logic;
    p19_tx_ready    : in  std_logic;
    p19_tx_error    : in  std_logic;
    p19_tx_reset    : in  std_logic;

    p20_rx_clk      : in  std_logic;
    p20_rx_data     : in  std_logic_vector(7 downto 0);
    p20_rx_last     : in  std_logic;
    p20_rx_write    : in  std_logic;
    p20_rx_error    : in  std_logic;
    p20_rx_rate     : in  std_logic_vector(15 downto 0);
    p20_rx_reset    : in  std_logic;
    p20_tx_clk      : in  std_logic;
    p20_tx_data     : out std_logic_vector(7 downto 0);
    p20_tx_last     : out std_logic;
    p20_tx_valid    : out std_logic;
    p20_tx_ready    : in  std_logic;
    p20_tx_error    : in  std_logic;
    p20_tx_reset    : in  std_logic;

    p21_rx_clk      : in  std_logic;
    p21_rx_data     : in  std_logic_vector(7 downto 0);
    p21_rx_last     : in  std_logic;
    p21_rx_write    : in  std_logic;
    p21_rx_error    : in  std_logic;
    p21_rx_rate     : in  std_logic_vector(15 downto 0);
    p21_rx_reset    : in  std_logic;
    p21_tx_clk      : in  std_logic;
    p21_tx_data     : out std_logic_vector(7 downto 0);
    p21_tx_last     : out std_logic;
    p21_tx_valid    : out std_logic;
    p21_tx_ready    : in  std_logic;
    p21_tx_error    : in  std_logic;
    p21_tx_reset    : in  std_logic;

    p22_rx_clk      : in  std_logic;
    p22_rx_data     : in  std_logic_vector(7 downto 0);
    p22_rx_last     : in  std_logic;
    p22_rx_write    : in  std_logic;
    p22_rx_error    : in  std_logic;
    p22_rx_rate     : in  std_logic_vector(15 downto 0);
    p22_rx_reset    : in  std_logic;
    p22_tx_clk      : in  std_logic;
    p22_tx_data     : out std_logic_vector(7 downto 0);
    p22_tx_last     : out std_logic;
    p22_tx_valid    : out std_logic;
    p22_tx_ready    : in  std_logic;
    p22_tx_error    : in  std_logic;
    p22_tx_reset    : in  std_logic;

    p23_rx_clk      : in  std_logic;
    p23_rx_data     : in  std_logic_vector(7 downto 0);
    p23_rx_last     : in  std_logic;
    p23_rx_write    : in  std_logic;
    p23_rx_error    : in  std_logic;
    p23_rx_rate     : in  std_logic_vector(15 downto 0);
    p23_rx_reset    : in  std_logic;
    p23_tx_clk      : in  std_logic;
    p23_tx_data     : out std_logic_vector(7 downto 0);
    p23_tx_last     : out std_logic;
    p23_tx_valid    : out std_logic;
    p23_tx_ready    : in  std_logic;
    p23_tx_error    : in  std_logic;
    p23_tx_reset    : in  std_logic;

    p24_rx_clk      : in  std_logic;
    p24_rx_data     : in  std_logic_vector(7 downto 0);
    p24_rx_last     : in  std_logic;
    p24_rx_write    : in  std_logic;
    p24_rx_error    : in  std_logic;
    p24_rx_rate     : in  std_logic_vector(15 downto 0);
    p24_rx_reset    : in  std_logic;
    p24_tx_clk      : in  std_logic;
    p24_tx_data     : out std_logic_vector(7 downto 0);
    p24_tx_last     : out std_logic;
    p24_tx_valid    : out std_logic;
    p24_tx_ready    : in  std_logic;
    p24_tx_error    : in  std_logic;
    p24_tx_reset    : in  std_logic;

    p25_rx_clk      : in  std_logic;
    p25_rx_data     : in  std_logic_vector(7 downto 0);
    p25_rx_last     : in  std_logic;
    p25_rx_write    : in  std_logic;
    p25_rx_error    : in  std_logic;
    p25_rx_rate     : in  std_logic_vector(15 downto 0);
    p25_rx_reset    : in  std_logic;
    p25_tx_clk      : in  std_logic;
    p25_tx_data     : out std_logic_vector(7 downto 0);
    p25_tx_last     : out std_logic;
    p25_tx_valid    : out std_logic;
    p25_tx_ready    : in  std_logic;
    p25_tx_error    : in  std_logic;
    p25_tx_reset    : in  std_logic;

    p26_rx_clk      : in  std_logic;
    p26_rx_data     : in  std_logic_vector(7 downto 0);
    p26_rx_last     : in  std_logic;
    p26_rx_write    : in  std_logic;
    p26_rx_error    : in  std_logic;
    p26_rx_rate     : in  std_logic_vector(15 downto 0);
    p26_rx_reset    : in  std_logic;
    p26_tx_clk      : in  std_logic;
    p26_tx_data     : out std_logic_vector(7 downto 0);
    p26_tx_last     : out std_logic;
    p26_tx_valid    : out std_logic;
    p26_tx_ready    : in  std_logic;
    p26_tx_error    : in  std_logic;
    p26_tx_reset    : in  std_logic;

    p27_rx_clk      : in  std_logic;
    p27_rx_data     : in  std_logic_vector(7 downto 0);
    p27_rx_last     : in  std_logic;
    p27_rx_write    : in  std_logic;
    p27_rx_error    : in  std_logic;
    p27_rx_rate     : in  std_logic_vector(15 downto 0);
    p27_rx_reset    : in  std_logic;
    p27_tx_clk      : in  std_logic;
    p27_tx_data     : out std_logic_vector(7 downto 0);
    p27_tx_last     : out std_logic;
    p27_tx_valid    : out std_logic;
    p27_tx_ready    : in  std_logic;
    p27_tx_error    : in  std_logic;
    p27_tx_reset    : in  std_logic;

    p28_rx_clk      : in  std_logic;
    p28_rx_data     : in  std_logic_vector(7 downto 0);
    p28_rx_last     : in  std_logic;
    p28_rx_write    : in  std_logic;
    p28_rx_error    : in  std_logic;
    p28_rx_rate     : in  std_logic_vector(15 downto 0);
    p28_rx_reset    : in  std_logic;
    p28_tx_clk      : in  std_logic;
    p28_tx_data     : out std_logic_vector(7 downto 0);
    p28_tx_last     : out std_logic;
    p28_tx_valid    : out std_logic;
    p28_tx_ready    : in  std_logic;
    p28_tx_error    : in  std_logic;
    p28_tx_reset    : in  std_logic;

    p29_rx_clk      : in  std_logic;
    p29_rx_data     : in  std_logic_vector(7 downto 0);
    p29_rx_last     : in  std_logic;
    p29_rx_write    : in  std_logic;
    p29_rx_error    : in  std_logic;
    p29_rx_rate     : in  std_logic_vector(15 downto 0);
    p29_rx_reset    : in  std_logic;
    p29_tx_clk      : in  std_logic;
    p29_tx_data     : out std_logic_vector(7 downto 0);
    p29_tx_last     : out std_logic;
    p29_tx_valid    : out std_logic;
    p29_tx_ready    : in  std_logic;
    p29_tx_error    : in  std_logic;
    p29_tx_reset    : in  std_logic;

    p30_rx_clk      : in  std_logic;
    p30_rx_data     : in  std_logic_vector(7 downto 0);
    p30_rx_last     : in  std_logic;
    p30_rx_write    : in  std_logic;
    p30_rx_error    : in  std_logic;
    p30_rx_rate     : in  std_logic_vector(15 downto 0);
    p30_rx_reset    : in  std_logic;
    p30_tx_clk      : in  std_logic;
    p30_tx_data     : out std_logic_vector(7 downto 0);
    p30_tx_last     : out std_logic;
    p30_tx_valid    : out std_logic;
    p30_tx_ready    : in  std_logic;
    p30_tx_error    : in  std_logic;
    p30_tx_reset    : in  std_logic;

    p31_rx_clk      : in  std_logic;
    p31_rx_data     : in  std_logic_vector(7 downto 0);
    p31_rx_last     : in  std_logic;
    p31_rx_write    : in  std_logic;
    p31_rx_error    : in  std_logic;
    p31_rx_rate     : in  std_logic_vector(15 downto 0);
    p31_rx_reset    : in  std_logic;
    p31_tx_clk      : in  std_logic;
    p31_tx_data     : out std_logic_vector(7 downto 0);
    p31_tx_last     : out std_logic;
    p31_tx_valid    : out std_logic;
    p31_tx_ready    : in  std_logic;
    p31_tx_error    : in  std_logic;
    p31_tx_reset    : in  std_logic;

    -- Error reporting (see switch_aux).
    errvec_t        : out std_logic_vector(7 downto 0);

    -- Statistics reporting (AXI-Lite)
    axi_clk         : in  std_logic;
    axi_aresetn     : in  std_logic;
    axi_awaddr      : in  std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    axi_awvalid     : in  std_logic;
    axi_awready     : out std_logic;
    axi_wdata       : in  std_logic_vector(31 downto 0);
    axi_wstrb       : in  std_logic_vector(3 downto 0);
    axi_wvalid      : in  std_logic;
    axi_wready      : out std_logic;
    axi_bresp       : out std_logic_vector(1 downto 0);
    axi_bvalid      : out std_logic;
    axi_bready      : in  std_logic;
    axi_araddr      : in  std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    axi_arvalid     : in  std_logic;
    axi_arready     : out std_logic;
    axi_rdata       : out std_logic_vector(31 downto 0);
    axi_rresp       : out std_logic_vector(1 downto 0);
    axi_rvalid      : out std_logic;
    axi_rready      : in  std_logic;

    -- Statistics reporting (UART)
    uart_txd        : out std_logic;
    uart_rxd        : in  std_logic;

    -- System interface.
    scrub_req_t     : in  std_logic;    -- Request MAC-lookup scrub
    core_clk        : in  std_logic;    -- Core datapath clock
    reset_p         : in  std_logic);   -- Core async reset
end wrap_switch_core;

architecture wrap_switch_core of wrap_switch_core is

signal rx_data  : array_rx_m2s(PORT_COUNT-1 downto 0);
signal tx_data  : array_tx_m2s(PORT_COUNT-1 downto 0);
signal tx_ctrl  : array_tx_s2m(PORT_COUNT-1 downto 0);

begin

-- Convert port signals.
gen_p00 : if (PORT_COUNT > 0) generate
    rx_data(0).clk      <= p00_rx_clk;
    rx_data(0).data     <= p00_rx_data;
    rx_data(0).last     <= p00_rx_last;
    rx_data(0).write    <= p00_rx_write;
    rx_data(0).rxerr    <= p00_rx_error;
    rx_data(0).rate     <= p00_rx_rate;
    rx_data(0).reset_p  <= p00_rx_reset;
    tx_ctrl(0).clk      <= p00_tx_clk;
    tx_ctrl(0).ready    <= p00_tx_ready;
    tx_ctrl(0).txerr    <= p00_tx_error;
    tx_ctrl(0).reset_p  <= p00_tx_reset;
    p00_tx_data         <= tx_data(0).data;
    p00_tx_last         <= tx_data(0).last;
    p00_tx_valid        <= tx_data(0).valid;
end generate;

gen_n00 : if (PORT_COUNT < 1) generate
    p00_tx_data         <= (others => '0');
    p00_tx_last         <= '0';
    p00_tx_valid        <= '0';
end generate;

gen_p01 : if (PORT_COUNT > 1) generate
    rx_data(1).clk      <= p01_rx_clk;
    rx_data(1).data     <= p01_rx_data;
    rx_data(1).last     <= p01_rx_last;
    rx_data(1).write    <= p01_rx_write;
    rx_data(1).rxerr    <= p01_rx_error;
    rx_data(1).rate     <= p01_rx_rate;
    rx_data(1).reset_p  <= p01_rx_reset;
    tx_ctrl(1).clk      <= p01_tx_clk;
    tx_ctrl(1).ready    <= p01_tx_ready;
    tx_ctrl(1).txerr    <= p01_tx_error;
    tx_ctrl(1).reset_p  <= p01_tx_reset;
    p01_tx_data         <= tx_data(1).data;
    p01_tx_last         <= tx_data(1).last;
    p01_tx_valid        <= tx_data(1).valid;
end generate;

gen_n01 : if (PORT_COUNT < 2) generate
    p01_tx_data         <= (others => '0');
    p01_tx_last         <= '0';
    p01_tx_valid        <= '0';
end generate;

gen_p02 : if (PORT_COUNT > 2) generate
    rx_data(2).clk      <= p02_rx_clk;
    rx_data(2).data     <= p02_rx_data;
    rx_data(2).last     <= p02_rx_last;
    rx_data(2).write    <= p02_rx_write;
    rx_data(2).rxerr    <= p02_rx_error;
    rx_data(2).rate     <= p02_rx_rate;
    rx_data(2).reset_p  <= p02_rx_reset;
    tx_ctrl(2).clk      <= p02_tx_clk;
    tx_ctrl(2).ready    <= p02_tx_ready;
    tx_ctrl(2).txerr    <= p02_tx_error;
    tx_ctrl(2).reset_p  <= p02_tx_reset;
    p02_tx_data         <= tx_data(2).data;
    p02_tx_last         <= tx_data(2).last;
    p02_tx_valid        <= tx_data(2).valid;
end generate;

gen_n02 : if (PORT_COUNT < 3) generate
    p02_tx_data         <= (others => '0');
    p02_tx_last         <= '0';
    p02_tx_valid        <= '0';
end generate;

gen_p03 : if (PORT_COUNT > 3) generate
    rx_data(3).clk      <= p03_rx_clk;
    rx_data(3).data     <= p03_rx_data;
    rx_data(3).last     <= p03_rx_last;
    rx_data(3).write    <= p03_rx_write;
    rx_data(3).rxerr    <= p03_rx_error;
    rx_data(3).rate     <= p03_rx_rate;
    rx_data(3).reset_p  <= p03_rx_reset;
    tx_ctrl(3).clk      <= p03_tx_clk;
    tx_ctrl(3).ready    <= p03_tx_ready;
    tx_ctrl(3).txerr    <= p03_tx_error;
    tx_ctrl(3).reset_p  <= p03_tx_reset;
    p03_tx_data         <= tx_data(3).data;
    p03_tx_last         <= tx_data(3).last;
    p03_tx_valid        <= tx_data(3).valid;
end generate;

gen_n03 : if (PORT_COUNT < 4) generate
    p03_tx_data         <= (others => '0');
    p03_tx_last         <= '0';
    p03_tx_valid        <= '0';
end generate;

gen_p04 : if (PORT_COUNT > 4) generate
    rx_data(4).clk      <= p04_rx_clk;
    rx_data(4).data     <= p04_rx_data;
    rx_data(4).last     <= p04_rx_last;
    rx_data(4).write    <= p04_rx_write;
    rx_data(4).rxerr    <= p04_rx_error;
    rx_data(4).rate     <= p04_rx_rate;
    rx_data(4).reset_p  <= p04_rx_reset;
    tx_ctrl(4).clk      <= p04_tx_clk;
    tx_ctrl(4).ready    <= p04_tx_ready;
    tx_ctrl(4).txerr    <= p04_tx_error;
    tx_ctrl(4).reset_p  <= p04_tx_reset;
    p04_tx_data         <= tx_data(4).data;
    p04_tx_last         <= tx_data(4).last;
    p04_tx_valid        <= tx_data(4).valid;
end generate;

gen_n04 : if (PORT_COUNT < 5) generate
    p04_tx_data         <= (others => '0');
    p04_tx_last         <= '0';
    p04_tx_valid        <= '0';
end generate;

gen_p05 : if (PORT_COUNT > 5) generate
    rx_data(5).clk      <= p05_rx_clk;
    rx_data(5).data     <= p05_rx_data;
    rx_data(5).last     <= p05_rx_last;
    rx_data(5).write    <= p05_rx_write;
    rx_data(5).rxerr    <= p05_rx_error;
    rx_data(5).rate     <= p05_rx_rate;
    rx_data(5).reset_p  <= p05_rx_reset;
    tx_ctrl(5).clk      <= p05_tx_clk;
    tx_ctrl(5).ready    <= p05_tx_ready;
    tx_ctrl(5).txerr    <= p05_tx_error;
    tx_ctrl(5).reset_p  <= p05_tx_reset;
    p05_tx_data         <= tx_data(0).data;
    p05_tx_last         <= tx_data(0).last;
    p05_tx_valid        <= tx_data(0).valid;
end generate;

gen_n05 : if (PORT_COUNT < 6) generate
    p05_tx_data         <= (others => '0');
    p05_tx_last         <= '0';
    p05_tx_valid        <= '0';
end generate;

gen_p06 : if (PORT_COUNT > 6) generate
    rx_data(6).clk      <= p06_rx_clk;
    rx_data(6).data     <= p06_rx_data;
    rx_data(6).last     <= p06_rx_last;
    rx_data(6).write    <= p06_rx_write;
    rx_data(6).rxerr    <= p06_rx_error;
    rx_data(6).rate     <= p06_rx_rate;
    rx_data(6).reset_p  <= p06_rx_reset;
    tx_ctrl(6).clk      <= p06_tx_clk;
    tx_ctrl(6).ready    <= p06_tx_ready;
    tx_ctrl(6).txerr    <= p06_tx_error;
    tx_ctrl(6).reset_p  <= p06_tx_reset;
    p06_tx_data         <= tx_data(6).data;
    p06_tx_last         <= tx_data(6).last;
    p06_tx_valid        <= tx_data(6).valid;
end generate;

gen_n06 : if (PORT_COUNT < 7) generate
    p06_tx_data         <= (others => '0');
    p06_tx_last         <= '0';
    p06_tx_valid        <= '0';
end generate;

gen_p07 : if (PORT_COUNT > 7) generate
    rx_data(7).clk      <= p07_rx_clk;
    rx_data(7).data     <= p07_rx_data;
    rx_data(7).last     <= p07_rx_last;
    rx_data(7).write    <= p07_rx_write;
    rx_data(7).rxerr    <= p07_rx_error;
    rx_data(7).rate     <= p07_rx_rate;
    rx_data(7).reset_p  <= p07_rx_reset;
    tx_ctrl(7).clk      <= p07_tx_clk;
    tx_ctrl(7).ready    <= p07_tx_ready;
    tx_ctrl(7).txerr    <= p07_tx_error;
    tx_ctrl(7).reset_p  <= p07_tx_reset;
    p07_tx_data         <= tx_data(7).data;
    p07_tx_last         <= tx_data(7).last;
    p07_tx_valid        <= tx_data(7).valid;
end generate;

gen_n07 : if (PORT_COUNT < 8) generate
    p07_tx_data         <= (others => '0');
    p07_tx_last         <= '0';
    p07_tx_valid        <= '0';
end generate;

gen_p08 : if (PORT_COUNT > 8) generate
    rx_data(8).clk      <= p08_rx_clk;
    rx_data(8).data     <= p08_rx_data;
    rx_data(8).last     <= p08_rx_last;
    rx_data(8).write    <= p08_rx_write;
    rx_data(8).rxerr    <= p08_rx_error;
    rx_data(8).rate     <= p08_rx_rate;
    rx_data(8).reset_p  <= p08_rx_reset;
    tx_ctrl(8).clk      <= p08_tx_clk;
    tx_ctrl(8).ready    <= p08_tx_ready;
    tx_ctrl(8).txerr    <= p08_tx_error;
    tx_ctrl(8).reset_p  <= p08_tx_reset;
    p08_tx_data         <= tx_data(8).data;
    p08_tx_last         <= tx_data(8).last;
    p08_tx_valid        <= tx_data(8).valid;
end generate;

gen_n08 : if (PORT_COUNT < 9) generate
    p08_tx_data         <= (others => '0');
    p08_tx_last         <= '0';
    p08_tx_valid        <= '0';
end generate;

gen_p09 : if (PORT_COUNT > 9) generate
    rx_data(9).clk      <= p09_rx_clk;
    rx_data(9).data     <= p09_rx_data;
    rx_data(9).last     <= p09_rx_last;
    rx_data(9).write    <= p09_rx_write;
    rx_data(9).rxerr    <= p09_rx_error;
    rx_data(9).rate     <= p09_rx_rate;
    rx_data(9).reset_p  <= p09_rx_reset;
    tx_ctrl(9).clk      <= p09_tx_clk;
    tx_ctrl(9).ready    <= p09_tx_ready;
    tx_ctrl(9).txerr    <= p09_tx_error;
    tx_ctrl(9).reset_p  <= p09_tx_reset;
    p09_tx_data         <= tx_data(9).data;
    p09_tx_last         <= tx_data(9).last;
    p09_tx_valid        <= tx_data(9).valid;
end generate;

gen_n09 : if (PORT_COUNT < 10) generate
    p09_tx_data         <= (others => '0');
    p09_tx_last         <= '0';
    p09_tx_valid        <= '0';
end generate;

gen_p10 : if (PORT_COUNT > 10) generate
    rx_data(10).clk     <= p10_rx_clk;
    rx_data(10).data    <= p10_rx_data;
    rx_data(10).last    <= p10_rx_last;
    rx_data(10).write   <= p10_rx_write;
    rx_data(10).rxerr   <= p10_rx_error;
    rx_data(10).rate    <= p10_rx_rate;
    rx_data(10).reset_p <= p10_rx_reset;
    tx_ctrl(10).clk     <= p10_tx_clk;
    tx_ctrl(10).ready   <= p10_tx_ready;
    tx_ctrl(10).txerr   <= p10_tx_error;
    tx_ctrl(10).reset_p <= p10_tx_reset;
    p10_tx_data         <= tx_data(10).data;
    p10_tx_last         <= tx_data(10).last;
    p10_tx_valid        <= tx_data(10).valid;
end generate;

gen_n10 : if (PORT_COUNT < 11) generate
    p10_tx_data         <= (others => '0');
    p10_tx_last         <= '0';
    p10_tx_valid        <= '0';
end generate;

gen_p11 : if (PORT_COUNT > 11) generate
    rx_data(11).clk     <= p11_rx_clk;
    rx_data(11).data    <= p11_rx_data;
    rx_data(11).last    <= p11_rx_last;
    rx_data(11).write   <= p11_rx_write;
    rx_data(11).rxerr   <= p11_rx_error;
    rx_data(11).rate    <= p11_rx_rate;
    rx_data(11).reset_p <= p11_rx_reset;
    tx_ctrl(11).clk     <= p11_tx_clk;
    tx_ctrl(11).ready   <= p11_tx_ready;
    tx_ctrl(11).txerr   <= p11_tx_error;
    tx_ctrl(11).reset_p <= p11_tx_reset;
    p11_tx_data         <= tx_data(11).data;
    p11_tx_last         <= tx_data(11).last;
    p11_tx_valid        <= tx_data(11).valid;
end generate;

gen_n11 : if (PORT_COUNT < 12) generate
    p11_tx_data         <= (others => '0');
    p11_tx_last         <= '0';
    p11_tx_valid        <= '0';
end generate;

gen_p12 : if (PORT_COUNT > 12) generate
    rx_data(12).clk     <= p12_rx_clk;
    rx_data(12).data    <= p12_rx_data;
    rx_data(12).last    <= p12_rx_last;
    rx_data(12).write   <= p12_rx_write;
    rx_data(12).rxerr   <= p12_rx_error;
    rx_data(12).rate    <= p12_rx_rate;
    rx_data(12).reset_p <= p12_rx_reset;
    tx_ctrl(12).clk     <= p12_tx_clk;
    tx_ctrl(12).ready   <= p12_tx_ready;
    tx_ctrl(12).txerr   <= p12_tx_error;
    tx_ctrl(12).reset_p <= p12_tx_reset;
    p12_tx_data         <= tx_data(12).data;
    p12_tx_last         <= tx_data(12).last;
    p12_tx_valid        <= tx_data(12).valid;
end generate;

gen_n12 : if (PORT_COUNT < 13) generate
    p12_tx_data         <= (others => '0');
    p12_tx_last         <= '0';
    p12_tx_valid        <= '0';
end generate;

gen_p13 : if (PORT_COUNT > 13) generate
    rx_data(13).clk     <= p13_rx_clk;
    rx_data(13).data    <= p13_rx_data;
    rx_data(13).last    <= p13_rx_last;
    rx_data(13).write   <= p13_rx_write;
    rx_data(13).rxerr   <= p13_rx_error;
    rx_data(13).rate    <= p13_rx_rate;
    rx_data(13).reset_p <= p13_rx_reset;
    tx_ctrl(13).clk     <= p13_tx_clk;
    tx_ctrl(13).ready   <= p13_tx_ready;
    tx_ctrl(13).txerr   <= p13_tx_error;
    tx_ctrl(13).reset_p <= p13_tx_reset;
    p13_tx_data         <= tx_data(13).data;
    p13_tx_last         <= tx_data(13).last;
    p13_tx_valid        <= tx_data(13).valid;
end generate;

gen_n13 : if (PORT_COUNT < 14) generate
    p13_tx_data         <= (others => '0');
    p13_tx_last         <= '0';
    p13_tx_valid        <= '0';
end generate;

gen_p14 : if (PORT_COUNT > 14) generate
    rx_data(14).clk     <= p14_rx_clk;
    rx_data(14).data    <= p14_rx_data;
    rx_data(14).last    <= p14_rx_last;
    rx_data(14).write   <= p14_rx_write;
    rx_data(14).rxerr   <= p14_rx_error;
    rx_data(14).rate    <= p14_rx_rate;
    rx_data(14).reset_p <= p14_rx_reset;
    tx_ctrl(14).clk     <= p14_tx_clk;
    tx_ctrl(14).ready   <= p14_tx_ready;
    tx_ctrl(14).txerr   <= p14_tx_error;
    tx_ctrl(14).reset_p <= p14_tx_reset;
    p14_tx_data         <= tx_data(14).data;
    p14_tx_last         <= tx_data(14).last;
    p14_tx_valid        <= tx_data(14).valid;
end generate;

gen_n14 : if (PORT_COUNT < 15) generate
    p14_tx_data         <= (others => '0');
    p14_tx_last         <= '0';
    p14_tx_valid        <= '0';
end generate;

gen_p15 : if (PORT_COUNT > 15) generate
    rx_data(15).clk     <= p15_rx_clk;
    rx_data(15).data    <= p15_rx_data;
    rx_data(15).last    <= p15_rx_last;
    rx_data(15).write   <= p15_rx_write;
    rx_data(15).rxerr   <= p15_rx_error;
    rx_data(15).rate    <= p15_rx_rate;
    rx_data(15).reset_p <= p15_rx_reset;
    tx_ctrl(15).clk     <= p15_tx_clk;
    tx_ctrl(15).ready   <= p15_tx_ready;
    tx_ctrl(15).txerr   <= p15_tx_error;
    tx_ctrl(15).reset_p <= p15_tx_reset;
    p15_tx_data         <= tx_data(15).data;
    p15_tx_last         <= tx_data(15).last;
    p15_tx_valid        <= tx_data(15).valid;
end generate;

gen_n15 : if (PORT_COUNT < 16) generate
    p15_tx_data         <= (others => '0');
    p15_tx_last         <= '0';
    p15_tx_valid        <= '0';
end generate;

gen_p16 : if (PORT_COUNT > 16) generate
    rx_data(16).clk     <= p16_rx_clk;
    rx_data(16).data    <= p16_rx_data;
    rx_data(16).last    <= p16_rx_last;
    rx_data(16).write   <= p16_rx_write;
    rx_data(16).rxerr   <= p16_rx_error;
    rx_data(16).rate    <= p16_rx_rate;
    rx_data(16).reset_p <= p16_rx_reset;
    tx_ctrl(16).clk     <= p16_tx_clk;
    tx_ctrl(16).ready   <= p16_tx_ready;
    tx_ctrl(16).txerr   <= p16_tx_error;
    tx_ctrl(16).reset_p <= p16_tx_reset;
    p16_tx_data         <= tx_data(16).data;
    p16_tx_last         <= tx_data(16).last;
    p16_tx_valid        <= tx_data(16).valid;
end generate;

gen_n16 : if (PORT_COUNT < 17) generate
    p16_tx_data         <= (others => '0');
    p16_tx_last         <= '0';
    p16_tx_valid        <= '0';
end generate;

gen_p17 : if (PORT_COUNT > 17) generate
    rx_data(17).clk     <= p17_rx_clk;
    rx_data(17).data    <= p17_rx_data;
    rx_data(17).last    <= p17_rx_last;
    rx_data(17).write   <= p17_rx_write;
    rx_data(17).rxerr   <= p17_rx_error;
    rx_data(17).rate    <= p17_rx_rate;
    rx_data(17).reset_p <= p17_rx_reset;
    tx_ctrl(17).clk     <= p17_tx_clk;
    tx_ctrl(17).ready   <= p17_tx_ready;
    tx_ctrl(17).txerr   <= p17_tx_error;
    tx_ctrl(17).reset_p <= p17_tx_reset;
    p17_tx_data         <= tx_data(17).data;
    p17_tx_last         <= tx_data(17).last;
    p17_tx_valid        <= tx_data(17).valid;
end generate;

gen_n17 : if (PORT_COUNT < 18) generate
    p17_tx_data         <= (others => '0');
    p17_tx_last         <= '0';
    p17_tx_valid        <= '0';
end generate;

gen_p18 : if (PORT_COUNT > 18) generate
    rx_data(18).clk     <= p18_rx_clk;
    rx_data(18).data    <= p18_rx_data;
    rx_data(18).last    <= p18_rx_last;
    rx_data(18).write   <= p18_rx_write;
    rx_data(18).rxerr   <= p18_rx_error;
    rx_data(18).rate    <= p18_rx_rate;
    rx_data(18).reset_p <= p18_rx_reset;
    tx_ctrl(18).clk     <= p18_tx_clk;
    tx_ctrl(18).ready   <= p18_tx_ready;
    tx_ctrl(18).txerr   <= p18_tx_error;
    tx_ctrl(18).reset_p <= p18_tx_reset;
    p18_tx_data         <= tx_data(18).data;
    p18_tx_last         <= tx_data(18).last;
    p18_tx_valid        <= tx_data(18).valid;
end generate;

gen_n18 : if (PORT_COUNT < 19) generate
    p18_tx_data         <= (others => '0');
    p18_tx_last         <= '0';
    p18_tx_valid        <= '0';
end generate;

gen_p19 : if (PORT_COUNT > 19) generate
    rx_data(19).clk     <= p19_rx_clk;
    rx_data(19).data    <= p19_rx_data;
    rx_data(19).last    <= p19_rx_last;
    rx_data(19).write   <= p19_rx_write;
    rx_data(19).rxerr   <= p19_rx_error;
    rx_data(19).rate    <= p19_rx_rate;
    rx_data(19).reset_p <= p19_rx_reset;
    tx_ctrl(19).clk     <= p19_tx_clk;
    tx_ctrl(19).ready   <= p19_tx_ready;
    tx_ctrl(19).txerr   <= p19_tx_error;
    tx_ctrl(19).reset_p <= p19_tx_reset;
    p19_tx_data         <= tx_data(19).data;
    p19_tx_last         <= tx_data(19).last;
    p19_tx_valid        <= tx_data(19).valid;
end generate;

gen_n19 : if (PORT_COUNT < 20) generate
    p19_tx_data         <= (others => '0');
    p19_tx_last         <= '0';
    p19_tx_valid        <= '0';
end generate;

gen_p20 : if (PORT_COUNT > 20) generate
    rx_data(20).clk     <= p20_rx_clk;
    rx_data(20).data    <= p20_rx_data;
    rx_data(20).last    <= p20_rx_last;
    rx_data(20).write   <= p20_rx_write;
    rx_data(20).rxerr   <= p20_rx_error;
    rx_data(20).rate    <= p20_rx_rate;
    rx_data(20).reset_p <= p20_rx_reset;
    tx_ctrl(20).clk     <= p20_tx_clk;
    tx_ctrl(20).ready   <= p20_tx_ready;
    tx_ctrl(20).txerr   <= p20_tx_error;
    tx_ctrl(20).reset_p <= p20_tx_reset;
    p20_tx_data         <= tx_data(20).data;
    p20_tx_last         <= tx_data(20).last;
    p20_tx_valid        <= tx_data(20).valid;
end generate;

gen_n20 : if (PORT_COUNT < 21) generate
    p20_tx_data         <= (others => '0');
    p20_tx_last         <= '0';
    p20_tx_valid        <= '0';
end generate;

gen_p21 : if (PORT_COUNT > 21) generate
    rx_data(21).clk     <= p21_rx_clk;
    rx_data(21).data    <= p21_rx_data;
    rx_data(21).last    <= p21_rx_last;
    rx_data(21).write   <= p21_rx_write;
    rx_data(21).rxerr   <= p21_rx_error;
    rx_data(21).rate    <= p21_rx_rate;
    rx_data(21).reset_p <= p21_rx_reset;
    tx_ctrl(21).clk     <= p21_tx_clk;
    tx_ctrl(21).ready   <= p21_tx_ready;
    tx_ctrl(21).txerr   <= p21_tx_error;
    tx_ctrl(21).reset_p <= p21_tx_reset;
    p21_tx_data         <= tx_data(21).data;
    p21_tx_last         <= tx_data(21).last;
    p21_tx_valid        <= tx_data(21).valid;
end generate;

gen_n21 : if (PORT_COUNT < 22) generate
    p21_tx_data         <= (others => '0');
    p21_tx_last         <= '0';
    p21_tx_valid        <= '0';
end generate;

gen_p22 : if (PORT_COUNT > 22) generate
    rx_data(22).clk     <= p22_rx_clk;
    rx_data(22).data    <= p22_rx_data;
    rx_data(22).last    <= p22_rx_last;
    rx_data(22).write   <= p22_rx_write;
    rx_data(22).rxerr   <= p22_rx_error;
    rx_data(22).rate    <= p22_rx_rate;
    rx_data(22).reset_p <= p22_rx_reset;
    tx_ctrl(22).clk     <= p22_tx_clk;
    tx_ctrl(22).ready   <= p22_tx_ready;
    tx_ctrl(22).txerr   <= p22_tx_error;
    tx_ctrl(22).reset_p <= p22_tx_reset;
    p22_tx_data         <= tx_data(22).data;
    p22_tx_last         <= tx_data(22).last;
    p22_tx_valid        <= tx_data(22).valid;
end generate;

gen_n22 : if (PORT_COUNT < 23) generate
    p22_tx_data         <= (others => '0');
    p22_tx_last         <= '0';
    p22_tx_valid        <= '0';
end generate;

gen_p23 : if (PORT_COUNT > 23) generate
    rx_data(23).clk     <= p23_rx_clk;
    rx_data(23).data    <= p23_rx_data;
    rx_data(23).last    <= p23_rx_last;
    rx_data(23).write   <= p23_rx_write;
    rx_data(23).rxerr   <= p23_rx_error;
    rx_data(23).rate    <= p23_rx_rate;
    rx_data(23).reset_p <= p23_rx_reset;
    tx_ctrl(23).clk     <= p23_tx_clk;
    tx_ctrl(23).ready   <= p23_tx_ready;
    tx_ctrl(23).txerr   <= p23_tx_error;
    tx_ctrl(23).reset_p <= p23_tx_reset;
    p23_tx_data         <= tx_data(23).data;
    p23_tx_last         <= tx_data(23).last;
    p23_tx_valid        <= tx_data(23).valid;
end generate;

gen_n23 : if (PORT_COUNT < 24) generate
    p23_tx_data         <= (others => '0');
    p23_tx_last         <= '0';
    p23_tx_valid        <= '0';
end generate;

gen_p24 : if (PORT_COUNT > 24) generate
    rx_data(24).clk     <= p24_rx_clk;
    rx_data(24).data    <= p24_rx_data;
    rx_data(24).last    <= p24_rx_last;
    rx_data(24).write   <= p24_rx_write;
    rx_data(24).rxerr   <= p24_rx_error;
    rx_data(24).rate    <= p24_rx_rate;
    rx_data(24).reset_p <= p24_rx_reset;
    tx_ctrl(24).clk     <= p24_tx_clk;
    tx_ctrl(24).ready   <= p24_tx_ready;
    tx_ctrl(24).txerr   <= p24_tx_error;
    tx_ctrl(24).reset_p <= p24_tx_reset;
    p24_tx_data         <= tx_data(24).data;
    p24_tx_last         <= tx_data(24).last;
    p24_tx_valid        <= tx_data(24).valid;
end generate;

gen_n24 : if (PORT_COUNT < 25) generate
    p24_tx_data         <= (others => '0');
    p24_tx_last         <= '0';
    p24_tx_valid        <= '0';
end generate;

gen_p25 : if (PORT_COUNT > 25) generate
    rx_data(25).clk     <= p25_rx_clk;
    rx_data(25).data    <= p25_rx_data;
    rx_data(25).last    <= p25_rx_last;
    rx_data(25).write   <= p25_rx_write;
    rx_data(25).rxerr   <= p25_rx_error;
    rx_data(25).rate    <= p25_rx_rate;
    rx_data(25).reset_p <= p25_rx_reset;
    tx_ctrl(25).clk     <= p25_tx_clk;
    tx_ctrl(25).ready   <= p25_tx_ready;
    tx_ctrl(25).txerr   <= p25_tx_error;
    tx_ctrl(25).reset_p <= p25_tx_reset;
    p25_tx_data         <= tx_data(25).data;
    p25_tx_last         <= tx_data(25).last;
    p25_tx_valid        <= tx_data(25).valid;
end generate;

gen_n25 : if (PORT_COUNT < 26) generate
    p25_tx_data         <= (others => '0');
    p25_tx_last         <= '0';
    p25_tx_valid        <= '0';
end generate;

gen_p26 : if (PORT_COUNT > 26) generate
    rx_data(26).clk     <= p26_rx_clk;
    rx_data(26).data    <= p26_rx_data;
    rx_data(26).last    <= p26_rx_last;
    rx_data(26).write   <= p26_rx_write;
    rx_data(26).rxerr   <= p26_rx_error;
    rx_data(26).rate    <= p26_rx_rate;
    rx_data(26).reset_p <= p26_rx_reset;
    tx_ctrl(26).clk     <= p26_tx_clk;
    tx_ctrl(26).ready   <= p26_tx_ready;
    tx_ctrl(26).txerr   <= p26_tx_error;
    tx_ctrl(26).reset_p <= p26_tx_reset;
    p26_tx_data         <= tx_data(26).data;
    p26_tx_last         <= tx_data(26).last;
    p26_tx_valid        <= tx_data(26).valid;
end generate;

gen_n26 : if (PORT_COUNT < 27) generate
    p26_tx_data         <= (others => '0');
    p26_tx_last         <= '0';
    p26_tx_valid        <= '0';
end generate;

gen_p27 : if (PORT_COUNT > 27) generate
    rx_data(27).clk     <= p27_rx_clk;
    rx_data(27).data    <= p27_rx_data;
    rx_data(27).last    <= p27_rx_last;
    rx_data(27).write   <= p27_rx_write;
    rx_data(27).rxerr   <= p27_rx_error;
    rx_data(27).rate    <= p27_rx_rate;
    rx_data(27).reset_p <= p27_rx_reset;
    tx_ctrl(27).clk     <= p27_tx_clk;
    tx_ctrl(27).ready   <= p27_tx_ready;
    tx_ctrl(27).txerr   <= p27_tx_error;
    tx_ctrl(27).reset_p <= p27_tx_reset;
    p27_tx_data         <= tx_data(27).data;
    p27_tx_last         <= tx_data(27).last;
    p27_tx_valid        <= tx_data(27).valid;
end generate;

gen_n27 : if (PORT_COUNT < 28) generate
    p27_tx_data         <= (others => '0');
    p27_tx_last         <= '0';
    p27_tx_valid        <= '0';
end generate;

gen_p28 : if (PORT_COUNT > 28) generate
    rx_data(28).clk     <= p28_rx_clk;
    rx_data(28).data    <= p28_rx_data;
    rx_data(28).last    <= p28_rx_last;
    rx_data(28).write   <= p28_rx_write;
    rx_data(28).rxerr   <= p28_rx_error;
    rx_data(28).rate    <= p28_rx_rate;
    rx_data(28).reset_p <= p28_rx_reset;
    tx_ctrl(28).clk     <= p28_tx_clk;
    tx_ctrl(28).ready   <= p28_tx_ready;
    tx_ctrl(28).txerr   <= p28_tx_error;
    tx_ctrl(28).reset_p <= p28_tx_reset;
    p28_tx_data         <= tx_data(28).data;
    p28_tx_last         <= tx_data(28).last;
    p28_tx_valid        <= tx_data(28).valid;
end generate;

gen_n28 : if (PORT_COUNT < 29) generate
    p28_tx_data         <= (others => '0');
    p28_tx_last         <= '0';
    p28_tx_valid        <= '0';
end generate;

gen_p29 : if (PORT_COUNT > 29) generate
    rx_data(29).clk     <= p29_rx_clk;
    rx_data(29).data    <= p29_rx_data;
    rx_data(29).last    <= p29_rx_last;
    rx_data(29).write   <= p29_rx_write;
    rx_data(29).rxerr   <= p29_rx_error;
    rx_data(29).rate    <= p29_rx_rate;
    rx_data(29).reset_p <= p29_rx_reset;
    tx_ctrl(29).clk     <= p29_tx_clk;
    tx_ctrl(29).ready   <= p29_tx_ready;
    tx_ctrl(29).txerr   <= p29_tx_error;
    tx_ctrl(29).reset_p <= p29_tx_reset;
    p29_tx_data         <= tx_data(29).data;
    p29_tx_last         <= tx_data(29).last;
    p29_tx_valid        <= tx_data(29).valid;
end generate;

gen_n29 : if (PORT_COUNT < 30) generate
    p29_tx_data         <= (others => '0');
    p29_tx_last         <= '0';
    p29_tx_valid        <= '0';
end generate;

gen_p30 : if (PORT_COUNT > 30) generate
    rx_data(30).clk     <= p30_rx_clk;
    rx_data(30).data    <= p30_rx_data;
    rx_data(30).last    <= p30_rx_last;
    rx_data(30).write   <= p30_rx_write;
    rx_data(30).rxerr   <= p30_rx_error;
    rx_data(30).rate    <= p30_rx_rate;
    rx_data(30).reset_p <= p30_rx_reset;
    tx_ctrl(30).clk     <= p30_tx_clk;
    tx_ctrl(30).ready   <= p30_tx_ready;
    tx_ctrl(30).txerr   <= p30_tx_error;
    tx_ctrl(30).reset_p <= p30_tx_reset;
    p30_tx_data         <= tx_data(30).data;
    p30_tx_last         <= tx_data(30).last;
    p30_tx_valid        <= tx_data(30).valid;
end generate;

gen_n30 : if (PORT_COUNT < 31) generate
    p30_tx_data         <= (others => '0');
    p30_tx_last         <= '0';
    p30_tx_valid        <= '0';
end generate;

gen_p31 : if (PORT_COUNT > 31) generate
    rx_data(31).clk     <= p31_rx_clk;
    rx_data(31).data    <= p31_rx_data;
    rx_data(31).last    <= p31_rx_last;
    rx_data(31).write   <= p31_rx_write;
    rx_data(31).rxerr   <= p31_rx_error;
    rx_data(31).rate    <= p31_rx_rate;
    rx_data(31).reset_p <= p31_rx_reset;
    tx_ctrl(31).clk     <= p31_tx_clk;
    tx_ctrl(31).ready   <= p31_tx_ready;
    tx_ctrl(31).txerr   <= p31_tx_error;
    tx_ctrl(31).reset_p <= p31_tx_reset;
    p31_tx_data         <= tx_data(31).data;
    p31_tx_last         <= tx_data(31).last;
    p31_tx_valid        <= tx_data(31).valid;
end generate;

gen_n31 : if (PORT_COUNT < 32) generate
    p31_tx_data         <= (others => '0');
    p31_tx_last         <= '0';
    p31_tx_valid        <= '0';
end generate;

-- Optional statistics reporting (AXI-Lite)
gen_stats_axien : if STATS_AXI_EN generate
    -- Block enabled, instantiate it.
    u_stats : entity work.config_stats_axi
        generic map(
        PORT_COUNT  => PORT_COUNT,
        ADDR_WIDTH  => AXI_ADDR_WIDTH)
        port map(
        rx_data     => rx_data,
        tx_data     => tx_data,
        tx_ctrl     => tx_ctrl,
        axi_clk     => axi_clk,
        axi_aresetn => axi_aresetn,
        axi_awaddr  => axi_awaddr,
        axi_awvalid => axi_awvalid,
        axi_awready => axi_awready,
        axi_wdata   => axi_wdata,
        axi_wstrb   => axi_wstrb,
        axi_wvalid  => axi_wvalid,
        axi_wready  => axi_wready,
        axi_bresp   => axi_bresp,
        axi_bvalid  => axi_bvalid,
        axi_bready  => axi_bready,
        axi_araddr  => axi_araddr,
        axi_arvalid => axi_arvalid,
        axi_arready => axi_arready,
        axi_rdata   => axi_rdata,
        axi_rresp   => axi_rresp,
        axi_rvalid  => axi_rvalid,
        axi_rready  => axi_rready);
end generate;

gen_stats_axino : if not STATS_AXI_EN generate
    -- Tie off unused outputs.
    axi_awready <= '0';
    axi_wready  <= '0';
    axi_bresp   <= (others => '0');
    axi_bvalid  <= '0';
    axi_arready <= '0';
    axi_rdata   <= (others => '0');
    axi_rresp   <= (others => '0');
    axi_rvalid  <= '0';
end generate;

-- Optional statistics reporting (UART)
gen_stats_uarten : if STATS_UART_EN generate
    -- Block enabled, instantiate it.
    u_stats : entity work.config_stats_uart
        generic map(
        PORT_COUNT  => PORT_COUNT,
        BAUD_HZ     => STATS_UART_BAUD,
        REFCLK_HZ   => CORE_CLK_HZ)
        port map(
        rx_data     => rx_data,
        tx_data     => tx_data,
        tx_ctrl     => tx_ctrl,
        uart_txd    => uart_txd,
        uart_rxd    => uart_rxd,
        refclk      => core_clk,
        reset_p     => reset_p);
end generate;

gen_stats_uartno : if not STATS_UART_EN generate
    -- Block disabled, tie off unused outputs.
    uart_txd    <= '1';
end generate;

-- Unit being wrapped.
u_wrap : entity work.switch_core
    generic map(
    CORE_CLK_HZ     => CORE_CLK_HZ,
    SUPPORT_PAUSE   => SUPPORT_PAUSE,
    ALLOW_JUMBO     => ALLOW_JUMBO,
    ALLOW_RUNT      => ALLOW_RUNT,
    PORT_COUNT      => PORT_COUNT,
    DATAPATH_BYTES  => DATAPATH_BYTES,
    IBUF_KBYTES     => IBUF_KBYTES,
    OBUF_KBYTES     => OBUF_KBYTES,
    MAC_LOOKUP_TYPE => "LUTRAM",
    MAC_TABLE_SIZE  => MAC_TABLE_SIZE,
    SCRUB_TIMEOUT   => SCRUB_TIMEOUT)
    port map(
    ports_rx_data   => rx_data,
    ports_tx_data   => tx_data,
    ports_tx_ctrl   => tx_ctrl,
    errvec_t        => errvec_t,
    scrub_req_t     => scrub_req_t,
    core_clk        => core_clk,
    core_reset_p    => reset_p);

end wrap_switch_core;
