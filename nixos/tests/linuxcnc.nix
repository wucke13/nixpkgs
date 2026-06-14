{ hostPkgs, ... }:
{
  name = "linuxcnc";

  nodes.machine =
    { nodes, pkgs, ... }:
    let
      user = nodes.machine.users.users.alice;
    in
    {
      imports = [
        ./common/user-account.nix
        ./common/x11.nix
      ];
      test-support.displayManager.auto.user = user.name;
      virtualisation.memorySize = 4096;

      programs.linuxcnc.enable = true;
      environment = {
        variables.LINUXCNC_FORCE_REALTIME = "1";
        systemPackages = [ pkgs.xdotool ];
      };
    };

  enableOCR = true;
  extraPythonPackages =
    ps: with ps; [
      pytesseract
    ];

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
    in
    ''
      import pytesseract
      import shlex

      machine.wait_for_x()

      # required so that wait_for_window can access alice's X session
      machine.succeed("xauth merge ~${user.name}/.Xauthority")

      def spawn_as_user(command: str):
        command += " >&2 &"
        escaped_command = shlex.quote(command)
        machine.succeed(f"su - ${user.name} -c -- {escaped_command}")

      def window_close():
        machine.succeed("xdotool getactivewindow windowquit")

      def window_maximize():
        machine.succeed("xdotool getactivewindow windowsize --sync 100% 100%")

      screenshot_counter: int = 0
      def screenshot(name: str) -> str:
        global screenshot_counter
        file_stem = f"{screenshot_counter:02d}-{name}"
        machine.screenshot(file_stem)
        screenshot_counter += 1
        return file_stem + ".png"

      def mouse_move_to_text(search_term: str, nth_match: int = 0, image_path: str | None = None) -> bool:
        if not image_path:
          machine.succeed("xdotool mousemove_relative --sync 8192 8192")
          temp_image_stem ="temp-mouse-move"
          machine.screenshot(temp_image_stem)
          image_path = temp_image_stem + ".png"

        data = pytesseract.image_to_data(image_path, output_type=pytesseract.Output.DICT)

        try:
          text_matches = [i for i, text in enumerate(data["text"]) if search_term == text]
          i = text_matches[nth_match]
          (x, y, w, h) = (data["left"][i], data["top"][i], data["width"][i], data["height"][i])
          machine.succeed(f"xdotool mousemove --sync {int(x + w / 2)} {int(y + h / 2)}")
          return True
        except IndexError:
          return False

      def mouse_click(button=1):
        machine.succeed(f"xdotool click {button}")

      with subtest("Test latency-test"):
        spawn_as_user("latency-test")
        machine.wait_for_window("LinuxCNC / HAL Latency Test")
        machine.wait_for_text("Let this test run for a few minutes")
        machine.wait_for_text("Reset Statistics")
        screenshot("latency-test")
        window_close()
        machine.wait_until_fails("pgrep rtapi_app")

      with subtest("Test latency-histogram"):
        spawn_as_user("latency-histogram")
        machine.wait_for_window("latency-histogram")
        machine.wait_for_text("ylogscale")
        machine.wait_for_text("binsize")
        screenshot("latency-histogram")
        window_close()
        machine.wait_until_fails("pgrep rtapi_app")

      with subtest("Test latency-plot"):
        spawn_as_user("latency-plot")
        machine.wait_for_window("latency-plot")
        window_maximize()
        machine.wait_for_text("Latency \\S+ vs Time \\S+")
        machine.wait_for_text("Pts")
        screenshot("latency-plot")
        window_close()
        machine.wait_until_fails("pgrep rtapi_app")


      with subtest("Test LinuxCNC configuration selector"):
        spawn_as_user("linuxcnc")
        machine.wait_for_window("LinuxCNC Configuration Selector")
        window_maximize()
        machine.wait_for_text("Welcome to LinuxCNC.")
        screenshot("linuxcnc-configuration-selector")

      with subtest("Test copy to new AXIS config"):
        machine.send_key("ret")
        machine.wait_for_text("Would you like to copy the")
        machine.send_key("ret")
        machine.wait_for_text("The configuration file has been copied to")
        machine.send_key("ret")

      with subtest("Test AXIS GUI"):
        # The "AXIS Manual Toolchanger" window will appear briefly
        machine.wait_for_window("^axis.ngc")
        window_maximize()
        machine.wait_for_text("ESTOP")
        screenshot("linuxcnc-axis")

        # Basic test of AXIS
        machine.send_key("f1") # toggle e-stop
        machine.wait_for_text("OFF")
        machine.send_key("f2") # toggle machine power to on
        machine.wait_for_text("ON")
        machine.send_key("f4") # switch from Preview to DRO
        machine.send_key("ctrl-home") # home all axes
        machine.sleep(5) # wait until homing is at least started
        machine.wait_for_text("X:\\s+0.0000") # wait until homing is done
        machine.wait_for_text("Y:\\s+0.0000")
        machine.wait_for_text("Z:\\s+0.0000")
        machine.send_key("f5") # switch from Manual Control to MDI
        machine.send_chars("G0 X.1337 Y.42 Z-.13\n") # go to specific coordinates
        machine.wait_for_text("0.1337") # wait until machine reached desired X coordinate
        screenshot("linuxcnc-axis-moved-mdi-dro")
        machine.send_key("f4") # switch from DRO to Preview
        machine.sleep(5) # avoid the keys beeing eaten
        machine.send_key("f3") # switch from MDI to Manual Control
        machine.wait_for_text("Touch off") # wait for Manual Control to be rendered
        screenshot("linuxcnc-axis-moved-manual-control-preview")

      with subtest("Test image-to-gcode"):
        machine.copy_from_host("${hostPkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png",
          "/home/${user.name}/linuxcnc/nc_files/test-image.png")
        machine.send_key("o")
        machine.wait_for_window("Open")
        machine.send_chars("test-image.png\n")
        machine.wait_for_window("Image to G-code")
        screenshot("linuxcnc-axis-image-to-gcode")
        machine.send_key("ret")
        machine.wait_for_text("M3")
        machine.wait_for_text("P3")
        screenshot("linuxcnc-axis-image-to-gcode-preview")

      with subtest("Test shutdown AXIS"):
        window_close()
        machine.wait_for_text("Do you really want to close LinuxCNC?")
        machine.send_key("tab")
        machine.send_key("ret")
        machine.wait_until_fails("pgrep rtapi_app")

      with subtest("Test gmoccapy GUI"):
        spawn_as_user("linuxcnc")
        machine.wait_for_window("LinuxCNC Configuration Selector")
        window_maximize()
        machine.wait_for_text("Welcome to LinuxCNC.")

        # fold "My Configurations"
        mouse_move_to_text("My")
        mouse_click()
        machine.send_key("left")

        # Select "Sample Configurations"
        mouse_move_to_text("Sample")
        mouse_click()
        machine.send_key("right")
        mouse_move_to_text("gmoccapy")
        machine.send_key("right")
        machine.send_key("down")
        machine.send_key("ret")

      with subtest("Test copy to new gmoccapy config"):
        machine.send_key("ret")
        machine.wait_for_text("Would you like to copy the")
        machine.send_key("ret")
        machine.wait_for_text("The configuration file has been copied to")
        machine.send_key("ret")

      with subtest("Test gmoccapy GUI"):
        machine.wait_for_window("^gmoccapy for LinuxCNC")
        screenshot("linuxcnc-gmoccapy")

      machine.shutdown()
    '';
}
