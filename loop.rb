require 'json'
require_relative 'rr_interface'
require_relative 'rr_servo_motor'

class Loop
  LOWER_MOTOR_ID = 34
  UPPER_MOTOR_ID = 35

  VELOCITY = 50
  ACCELERATION = 40

  L1, U1 = 150, 150
  L2, U2 = 120, 150
  L3, U3 = 90, 100
  L4, U4 = 150, 100

  def initialize
    @lower_motor = initialize_motor(LOWER_MOTOR_ID)
    @upper_motor = initialize_motor(UPPER_MOTOR_ID)
    @lower_motor.clear_points_queue
    @upper_motor.clear_points_queue
    move_to_initial_point

    run
  rescue => e
    puts e.message
    puts e.backtrace
  ensure
    # @left_motor.deinitialize
    # @right_motor.deinitialize
    # @servo_interface&.deinitialize
  end

  def move_to_initial_point
    @lower_motor.clear_points_queue
    @upper_motor.clear_points_queue
    left_point = 150
    right_point = 150

    @lower_motor.go_to(pos: left_point, max_velocity: VELOCITY, acceleration: ACCELERATION)
    @upper_motor.go_to(pos: right_point, max_velocity: VELOCITY, acceleration: ACCELERATION)

    @lower_motor.add_motion_point(left_point, 0, 0, 1000)
    @upper_motor.add_motion_point(right_point, 0, 0, 1000)

    @servo_interface.start_motion
    sleep 6

  end

  def initialize_motor(id)
    device = case RUBY_PLATFORM
             when 'x86_64-darwin16'
               '/dev/cu.usbmodem3011'
             when 'armv7l-linux-eabihf'
               '/dev/serial/by-id/usb-Rozum_Robotics_USB-CAN_Interface_301-if00'
             when 'arm-linux-gnueabihf'
               '/dev/serial/by-id/usb-Rozum_Robotics_USB-CAN_Interface_301-if00'
             else
               'unknown_os'
             end
    @servo_interface ||= RRInterface.new(device)
    # @servo_interface ||= RRInterface.new('192.168.0.42')
    RRServoMotor.new(@servo_interface, id)
  end

  def run

    loop do
      tl = @lower_motor.go_to(pos: L1, max_velocity: VELOCITY, acceleration: ACCELERATION, start_immediately: false)
      tu = @upper_motor.go_to(pos: U1, max_velocity: VELOCITY, acceleration: ACCELERATION, start_immediately: false)
      @servo_interface.start_motion
      sleep [tl / 1000, tu / 1000].max + 0.5
      # p [@lower_motor.position, @upper_motor.position]

      tl = @lower_motor.go_to(pos: L2, max_velocity: VELOCITY, acceleration: ACCELERATION, start_immediately: false)
      tu = @upper_motor.go_to(pos: U2, max_velocity: VELOCITY, acceleration: ACCELERATION, start_immediately: false)
      @servo_interface.start_motion
      sleep [tl / 1000, tu / 1000].max + 0.5
      # p [@lower_motor.position, @upper_motor.position]

      tl = @lower_motor.go_to(pos: L3, max_velocity: VELOCITY, acceleration: ACCELERATION, start_immediately: false)
      tu = @upper_motor.go_to(pos: U3, max_velocity: VELOCITY, acceleration: ACCELERATION, start_immediately: false)
      @servo_interface.start_motion
      sleep [tl / 1000, tu / 1000].max + 0.5
      # p [@lower_motor.position, @upper_motor.position]

      tl = @lower_motor.go_to(pos: L4, max_velocity: VELOCITY, acceleration: ACCELERATION, start_immediately: false)
      tu = @upper_motor.go_to(pos: U4, max_velocity: VELOCITY, acceleration: ACCELERATION, start_immediately: false)
      @servo_interface.start_motion
      sleep [tl / 1000, tu / 1000].max + 0.5
      # p [@lower_motor.position, @upper_motor.position]


    end
  end
end
Loop.new

