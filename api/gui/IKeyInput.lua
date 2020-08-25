local IInputHandler = require("api.gui.IInputHandler")

return class.interface("IKeyInput",
                 {
                    receive_key = "function",
                    run_key_action = "function",
                    run_keybind_action = "function",
                    bind_keys = "function",
                    unbind_keys = "function",
                    key_held_frames = "function",
                    is_modifier_held = "function",
                    ignore_modifiers = "function",
                    release_key = "function"
                 },
                 IInputHandler)
