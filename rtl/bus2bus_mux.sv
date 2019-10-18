//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

module bus2bus_mux(
	input       sel_in,
	input       sel_out,
	input [1:0] bus_enable,
	bus_if      bus_in  [2],
	bus_if      bus_out [2]
);

task off_bus_out_0();
	bus_out[0].req   = 1'b0;
	bus_out[0].addr  = 'h0;
	bus_out[0].cmd   = 1'b0;
	bus_out[0].wdata = '0;
endtask

task off_bus_out_1();
	bus_out[1].req   = 1'b0;
	bus_out[1].addr  = 'h0;
	bus_out[1].cmd   = 1'b0;
	bus_out[1].wdata = '0;
endtask

task off_bus_in_0();
	bus_in[0].ack   = 1'b0;
	bus_in[0].rdata = 'h0;
	bus_in[0].resp  = 1'b0;
endtask

task off_bus_in_1();
	bus_in[1].ack   = 1'b0;
	bus_in[1].rdata = 'h0;
	bus_in[1].resp  = 1'b0;
endtask

task all_off();
	off_bus_out_0();
	off_bus_out_1();
	off_bus_in_0();
	off_bus_in_1();
endtask


always_comb begin
	case (sel_out)
		0: begin
			case (sel_in)
				0: begin
					bus_out[0].req   = bus_in[0].req & bus_enable[0];
					bus_out[0].addr  = bus_in[0].addr;
					bus_out[0].cmd   = bus_in[0].cmd;
					bus_out[0].wdata = bus_in[0].wdata;
					bus_in[0].ack    = bus_out[0].ack;
					bus_in[0].rdata  = bus_out[0].rdata;
					bus_in[0].resp   = bus_out[0].resp;
					off_bus_out_1();
					off_bus_in_1();
				end
				1: begin
					bus_out[0].req   = bus_in[1].req & bus_enable[1];
					bus_out[0].addr  = bus_in[1].addr;
					bus_out[0].cmd   = bus_in[1].cmd;
					bus_out[0].wdata = bus_in[1].wdata;
					bus_in[1].ack    = bus_out[0].ack;
					bus_in[1].rdata  = bus_out[0].rdata;
					bus_in[1].resp   = bus_out[0].resp;
					off_bus_out_1();
					off_bus_in_0();
				end
			endcase
		end
		1: begin
			case (sel_in)
				0: begin
					bus_out[1].req   = bus_in[0].req & bus_enable[0];
					bus_out[1].addr  = bus_in[0].addr;
					bus_out[1].cmd   = bus_in[0].cmd;
					bus_out[1].wdata = bus_in[0].wdata;
					bus_in[0].ack    = bus_out[1].ack;
					bus_in[0].rdata  = bus_out[1].rdata;
					bus_in[0].resp   = bus_out[1].resp;
					off_bus_out_0();
					off_bus_in_1();
				end
				1: begin
					bus_out[1].req   = bus_in[1].req & bus_enable[1];
					bus_out[1].addr  = bus_in[1].addr;
					bus_out[1].cmd   = bus_in[1].cmd;
					bus_out[1].wdata = bus_in[1].wdata;
					bus_in[1].ack    = bus_out[1].ack;
					bus_in[1].rdata  = bus_out[1].rdata;
					bus_in[1].resp   = bus_out[1].resp;
					off_bus_out_0();
					off_bus_in_0();
				end
			endcase
		end
		default
			all_off();
	endcase
end


endmodule
