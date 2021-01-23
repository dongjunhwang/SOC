`timescale 1ns / 1ps
module TFF_3bits_fileIO_tb( );
    reg clk, s181703fr_en, fwrite_en, fwrite_en_d, eof_flag;
    integer fp_in, fp_out, s181703eof, indata2;
    reg [3:0] btn, indata1;
    wire [3:0] led;
    wire reset = btn[3];
    parameter half_period = 10;
    initial begin
        clk = 1'b1;
        s181703fr_en =1'b0; fwrite_en = 1'b0; eof_flag = 1'b0;
        s181703eof = 0;
        btn = 4'b0000;
        fp_in = $fopen("C:\\SoC\\TFF_3bits_in.txt", "r");
        fp_out = $fopen("C:\\SoC\\TFF_3bits_oH.txt", "w");
        #(3 * half_period) s181703fr_en = 1'b1 ; // after 30ns
    end
    TFF_3bits UUT ( // TFF_3bits instantiation
        .sysclk (clk), .btn (btn), .led (led)
    );
    always @(posedge clk) begin
        fwrite_en <= s181703fr_en;
        fwrite_en_d <= fwrite_en;
    end
    always @(posedge clk) begin // read a line from the input file
        if ( s181703fr_en == 1 ) begin
            s181703eof = $fscanf(fp_in, "%4b %d\n", indata1, indata2);
            btn <= indata1;
            if ( s181703eof == -1 && fwrite_en == 1'b1 )
                s181703fr_en <= 1'b0;
            end
        end
    always @(posedge clk) begin
    if ( s181703eof == -1 && s181703fr_en == 1'b0 )
        eof_flag <= 1'b1;
    end
    always @(posedge clk) begin // write output
    if ( fwrite_en_d == 1 ) begin
        $fdisplay(fp_out,"%4b %d", led, led);
        if ( eof_flag == 1'b1 ) begin
            $fclose(fp_out);
            $display( "End of Simulation" );
            $stop;
        end
    end
    end
    always begin // clock gen(20MHz)
        #half_period clk = ~clk;
    end
endmodule