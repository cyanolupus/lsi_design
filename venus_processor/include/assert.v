task assert;
  input bool;
  if (!bool) begin
    $display("Assertion failed in %m");
    $finish;
  end else begin
    $display("Assertion passed in %m");
  end
endtask