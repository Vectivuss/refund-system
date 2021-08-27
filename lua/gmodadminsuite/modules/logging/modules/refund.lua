do end



if ( !SERVER ) then return end

refundLog = GAS.Logging:MODULE()

refundLog.Category = "Refund System"
refundLog.Name = "Logs"
refundLog.Colour = Color( 87, 39, 210 )

GAS.Logging:AddModule( refundLog )