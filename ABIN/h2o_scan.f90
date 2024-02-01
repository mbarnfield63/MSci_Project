program scan
    use mod_const, only: DP
    use mod_init, only: read_xyz_file
    implicit none
    external :: force_water

    integer, parameter :: natom = 3
    integer, parameter :: nbeads = 1
    integer, parameter :: watpot = 1 ! qTIP4P water model

    ! Displacement for H atom at each timestep
    real(DP) :: delta = 0.0005_DP

    real(DP) :: x(3, 1), y(3, 1), z(3, 1)
    real(DP) :: fx(3, 1), fy(3, 1), fz(3, 1)
    real(DP) :: energy, rOH
    integer :: i, funit, nsteps
    character(len=2) :: atom_names(3)
    character(len=256) :: fname

    atom_names = (/ "O", "H", "H" /)

    fname = "water.xyz"
    open (newunit=funit, file=fname, action="read")
    call read_xyz_file(funit, fname, atom_names, natom, nbeads, x, y, z)
    close (funit)

    ! print for output
    print*, "Step   ", "rOH   ", "Energy"


    open(99, file="water_geometries.xyz", action="write")
    ! steps for stretching OH bond
    nsteps = 2000
    do i = 1, nsteps
        ! Calculate the initial OH bond length (rOH) from initial bond positions
        rOH = sqrt((x(2, 1) - x(1, 1))**2 + (y(2, 1) - y(1, 1))**2 + (z(2, 1) - z(1, 1))**2)

        ! Modify the OH bond length by changing the position of a single hydrogen atom
        x(2, 1) = x(2, 1) + delta

        ! Call the force_water function to calculate forces and energy
        call force_water(x, y, z, fx, fy, fz, energy, natom, nbeads, watpot)

        ! Print the current OH bond length and energy
        print '(I4,F16.8,E18.8)', i, rOH, energy
        write(99, '(A,F12.6,F12.6,F12.6)') "O", x(1,1), y(1,1), z(1,1)
        write(99, '(A,F12.6,F12.6,F12.6)') "H", x(2,1), y(2,1), z(2,1)
        write(99, '(A,F12.6,F12.6,F12.6)') "H", x(3,1), y(3,1), z(3,1)
        write(99, *)
    end do

    ! close file
    close(99)
end program