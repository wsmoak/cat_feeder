# CatFeeder

Elixir code for a cat feeder that receives interrupts from a proximity sensor and triggers a stepper motor to turn an augur to deliver a small amount of food. It then waits 20 minutes before it can be activated again.

See related blog posts on <http://wsmoak.net>

The proximity sensor is a VCNL4010 from Adafruit
<https://www.adafruit.com/product/466>
<https://cdn-shop.adafruit.com/product-files/466/vcnl4010.pdf>

The stepper motor is controlled by a PCA9685 (among other things) on the Adafruit Stepper Motor HAT
<https://www.adafruit.com/products/2348>
<http://www.adafruit.com/datasheets/PCA9685.pdf>

Initially:
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix firmware.burn`

Subsequently:
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix firmware.burn --task upgrade` to avoid overwriting the appdata partition

To set the time:

Connect a monitor and keyboard to the RPi. After it boots, hit enter to get an iex prompt if one is not visible.  Enter `System.cmd("date",["MMDDHHMMYYYY"])` for the current time in UTC.
