//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

import bus_if_pkg::*;

module cross_bar(
	input         clk,
	input         reset,
	bus_if.master mbus[2],
	bus_if.slave  sbus[2]
);

enum int unsigned{
	IDLE,
	WRITE,
	READ
} state;

logic master;
logic target;

// to arbitrage: Round-robin
logic [0:0] enable;  // enable[1] is excessive

always_ff @(posedge clk) begin
	if (reset) begin
		state  <= IDLE;
		master <= 1'b0;
		target <= 1'b0;
	end else begin
		case (state)
			IDLE: begin
				if (mbus[0].req & enable[0]) begin
					master <= 1'b0;
					target <= mbus[0].addr[AW-1];

					if (mbus[0].cmd)
						state <= WRITE;
					else
						state <= READ;
				end
				else if (mbus[1].req) begin
					target <= mbus[1].addr[AW-1];
					master <= 1'b1;

					if (mbus[1].cmd)
						state <= WRITE;
					else
						state <= READ;
				end
			end

			WRITE: begin
				case (target)
					0: begin if (sbus[0].ack) state <= IDLE; end
					1: begin if (sbus[1].ack) state <= IDLE; end
				endcase
			end

			READ: begin
				case (target)
					0: begin if (sbus[0].resp) state <= IDLE; end
					1: begin if (sbus[1].resp) state <= IDLE; end
				endcase
			end
		endcase
	end
end

logic [1:0] request;
always_ff @(posedge clk) begin
	if (reset)
		request <= 1'b0;
	else begin
		if (state == IDLE) begin
			if (mbus[0].req)
				request[0] <= 1'b1;
		end
		else begin
			if ((target == 0) && sbus[0].ack)
				request[0] <= 1'b0;
			else if ((target == 1) && sbus[1].ack)
				request[0] <= 1'b0;
		end

		if (state == IDLE) begin
			if (mbus[1].req)
				request[1] <= 1'b1;
		end
		else begin
			if ((target == 0) && sbus[0].ack)
				request[1] <= 1'b0;
			else if ((target == 1) && sbus[1].ack)
				request[1] <= 1'b0;
		end
	end
end

always_ff @(posedge clk) begin
	if (reset) begin
		enable[0] <= 1'b1;
	end
	else begin
		if (state != IDLE) begin
			if (enable[0]) begin
				if (mbus[0].req & mbus[1].req)
					if ((target == 0) && sbus[0].ack)
						enable[0] <= 1'b0;
					else if ((target == 1) && sbus[1].ack)
						enable[0] <= 1'b0;
			end
			else begin
				if (mbus[1].req)
					if ((target == 0) && sbus[0].ack)
						enable[0] <= 1'b1;
					else if ((target == 1) && sbus[1].ack)
						enable[0] <= 1'b1;
			end
		end
	end
end


bus2bus_mux bus2bus_mux_0 (
	.sel_in     (master ),
	.sel_out    (target ),
	.bus_enable (request),
	.bus_in     (mbus   ),
	.bus_out    (sbus   )
);


endmodule
