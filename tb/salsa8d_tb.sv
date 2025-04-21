`timescale 1ns/100fs

module salsa8d_tb;

logic clk;
logic rst_n;
logic load;
logic [1023:0] state_in;
logic done;
logic [1023:0] state_out;
logic [1023:0] state_out_ref;

clocking dutif @(posedge clk);
    default input #0.1 output #0.1;
    output load, state_in;
    input done, state_out;
endclocking

localparam T = `T;

initial begin
    clk <= 1'b0;
    forever #(T / 2) clk <= !clk;
end

initial begin
    #(200 * T);
    $fatal("Timed out!");
end

salsa8d dut_i(
    .clk(clk),
    .rst_n(rst_n),

    .load(load),
    .state_in(state_in),

    .done(done),
    .state_out(state_out)
);

real st, et;

initial begin
`ifdef SDF
// `include "deposit.v"
    $fsdbDumpfile("netlist.fsdb");
`else
    $fsdbDumpfile("rtl.fsdb");
`endif
    $fsdbDumpvars();
    $fsdbDumpMDA();
    $fsdbDumpSVA();

`ifdef SDF
    $sdf_annotate("./out/salsa8d.sdf", dut_i, , "sdf_annotate.log", "MINIMUM");
`endif

    rst_n <= 1'b0;
    dutif.load <= 1'b0;

    dutif.state_in <= 1024'h606584d6_1bc2beb5_014fdbdf_0837cb3c_af0114be_81fa26a9_f185eca5_43791954_823315fd_db6a99f7_3aed54dc_80f5253d_68eec611_f6111167_8fe4b071_dd5d9fca_a3852ab8_49b78cc0_69f7be3d_adc69d40_5517e417_5f029d75_52efd38f_628a97b9_d8e55966_f6ca4e6b_fea69b3b_636f42ed_f9e8b147_8478c1a4_ffda79b1_6f801364;
    state_out_ref <= 1024'h015b5e3f_6a8e5a94_36ed5183_566018c9_2b185959_4b700fed_4acbd94e_c1bc7d73_3e3e43a6_49601d36_d2f70311_bdd8fe9e_6ea3c0d4_77163d8d_43a524d6_eab89fcc_c395ddb2_e7357a90_4e648784_8af3ec06_0a7e21cd_7f626d44_4ca279b5_8691eeb6_53798f39_527ceb5c_bb50c99c_e0107620_68311c93_21fe15a7_1d26680f_dcefed06;

    #(1 * T);
    rst_n <= 1'b1;
    #(1.5 * T);
    dutif.load <= 1'b1;
    st = $realtime;
    #(1 * T);
    dutif.load <= 1'b0;
    wait(dutif.done == '1);
    et = $realtime;
    assert(dutif.state_out == state_out_ref) else $display("ref: %h\nact: %h", state_out_ref, dutif.state_out);
    #(1 * T);
    $display("CUT %f %f", st, et);
    $finish();
end

endmodule
