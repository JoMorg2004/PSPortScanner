function Read-Port {
    param (
        [string]$target = $(Read-Host "Enter target IP or hostname"),
        [int]$startPort = 20,
        [int]$endPort = 1024
    )

    Write-Host "`nScanning $target from port $startPort to $endPort ...`n"

    foreach ($port in $startPort..$endPort) {
        try {
            $tcpClient = New-Object System.Net.Sockets.TcpClient
            $asyncResult = $tcpClient.BeginConnect($target, $port, $null, $null)
            $waitHandle = $asyncResult.AsyncWaitHandle

            if ($waitHandle.WaitOne(100, $false)) {
                $tcpClient.EndConnect($asyncResult)
                Write-Host "Port $port is OPEN"
                $tcpClient.Close()
            }

            $waitHandle.Close()
        } catch {
            # Optional: Write-Host "Port $port is closed"
        }
    }

    Write-Host "`nScan complete.`n"
}
