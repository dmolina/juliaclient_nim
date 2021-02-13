# uses this file as the main entry point of the application.
from os import fileExists, commandLineParams, getCurrentDir
import net
import re
from strutils import join
from strscans import scanf

proc main(port: int): int =
  var
    line: string
    args_str: string

  let args = commandLineParams()
  let num_args = args.len

  if num_args > 1:
    args_str = join(args[1..<num_args], sep=" ")
  else:
    args_str = ""

  # Check there is an argument
  if args.len == 0:
    stderr.writeLine("Error: missing filename")
    return 1

  # Get the filename
  let filename = args[0]

  # Check that exist the filename
  if not fileExists(filename):
    stderr.writeLine("Error: file '", filename, "' does not exist")
    return 1

  # Connect the socket
  var socket = newSocket()
  socket.connect("127.0.0.1", Port(port))
  # Send the token
  socket.send("DaemonMode::runfile\n")
  # Send the current directory
  socket.send(getCurrentDir() & "\n")
  # Send the filename
  socket.send(filename & "\n")
  # Send the arguments
  socket.send(args_str & "\n")
  readLine(socket, line)
  var error = 0

  while line.len > 0 and find(line, re"DaemonMode::end") < 0:
    stdout.writeLine(line)
    readLine(socket, line)

  if find(line, re"DaemonMode::end_ok") >= 0:
    line = replace(line, re"DaemonMode::end_ok", "")
    stdout.write(line)
    error = 0
  else:
    error = 1

  socket.close()
  return error

when isMainModule:
  let port_arg = os.getEnv("JULIA_DAEMON_PORT", "3000")
  var port: int

  if scanf(port_arg, "$i", port):
    system.quit(main(port))
  else:
    stderr.writeLine("Error, variable 'JULIA_DAEMON_PORT' is not a number")
