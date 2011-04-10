module mpi_io

  use core_lib
  use mpi
  use mpi_core

  implicit none
  save

  private

  integer :: ierr

  public :: mp_set_compression
  public :: mp_open_new
  public :: mp_open_read
  public :: mp_open_write
  public :: mp_path_exists
  public :: mp_open_group
  public :: mp_create_group
  public :: mp_close_group
  public :: mp_list_groups
  public :: mp_table_write_header
  public :: mp_exists_keyword

  public :: mp_read_keyword
  interface mp_read_keyword
     module procedure mp_read_keyword_mpi_real4
     module procedure mp_read_keyword_mpi_real8
     module procedure mp_read_keyword_mpi_integer4
     module procedure mp_read_keyword_mpi_integer8
     module procedure mp_read_keyword_mpi_logical
     module procedure mp_read_keyword_mpi_character
  end interface mp_read_keyword

  public :: mp_write_keyword
  interface mp_write_keyword
     module procedure mp_write_keyword_mpi_real4
     module procedure mp_write_keyword_mpi_real8
     module procedure mp_write_keyword_mpi_integer4
     module procedure mp_write_keyword_mpi_integer8
     module procedure mp_write_keyword_mpi_logical
     module procedure mp_write_keyword_mpi_character
  end interface mp_write_keyword

  public :: mp_table_read_column_auto
  interface mp_table_read_column_auto
     module procedure mp_table_read_column_auto_1d_mpi_real4
     module procedure mp_table_read_column_auto_1d_mpi_real8
     module procedure mp_table_read_column_auto_1d_mpi_integer4
     module procedure mp_table_read_column_auto_1d_mpi_integer8
     module procedure mp_table_read_column_auto_1d_mpi_character
     module procedure mp_table_read_column_auto_2d_mpi_real4
     module procedure mp_table_read_column_auto_2d_mpi_real8
     module procedure mp_table_read_column_auto_2d_mpi_integer4
     module procedure mp_table_read_column_auto_2d_mpi_integer8
  end interface mp_table_read_column_auto

  public :: mp_table_write_column
  interface mp_table_write_column
     module procedure mp_table_write_column_1d_mpi_real4
     module procedure mp_table_write_column_1d_mpi_real8
     module procedure mp_table_write_column_1d_mpi_integer4
     module procedure mp_table_write_column_1d_mpi_integer8
     module procedure mp_table_write_column_1d_mpi_character
     module procedure mp_table_write_column_2d_mpi_real4
     module procedure mp_table_write_column_2d_mpi_real8
     module procedure mp_table_write_column_2d_mpi_integer4
     module procedure mp_table_write_column_2d_mpi_integer8
  end interface mp_table_write_column

  public :: mp_read_array_auto
  interface mp_read_array_auto
     module procedure mp_read_array_auto_2d_mpi_real4
     module procedure mp_read_array_auto_2d_mpi_real8
     module procedure mp_read_array_auto_2d_mpi_integer4
     module procedure mp_read_array_auto_2d_mpi_integer8
     module procedure mp_read_array_auto_3d_mpi_real4
     module procedure mp_read_array_auto_3d_mpi_real8
     module procedure mp_read_array_auto_3d_mpi_integer4
     module procedure mp_read_array_auto_3d_mpi_integer8
     module procedure mp_read_array_auto_4d_mpi_real4
     module procedure mp_read_array_auto_4d_mpi_real8
     module procedure mp_read_array_auto_4d_mpi_integer4
     module procedure mp_read_array_auto_4d_mpi_integer8
     module procedure mp_read_array_auto_5d_mpi_real4
     module procedure mp_read_array_auto_5d_mpi_real8
     module procedure mp_read_array_auto_5d_mpi_integer4
     module procedure mp_read_array_auto_5d_mpi_integer8
     module procedure mp_read_array_auto_6d_mpi_real4
     module procedure mp_read_array_auto_6d_mpi_real8
     module procedure mp_read_array_auto_6d_mpi_integer4
     module procedure mp_read_array_auto_6d_mpi_integer8
  end interface mp_read_array_auto

  public :: mp_write_array
  interface mp_write_array
     module procedure mp_write_array_2d_mpi_real4
     module procedure mp_write_array_2d_mpi_real8
     module procedure mp_write_array_2d_mpi_integer4
     module procedure mp_write_array_2d_mpi_integer8
     module procedure mp_write_array_3d_mpi_real4
     module procedure mp_write_array_3d_mpi_real8
     module procedure mp_write_array_3d_mpi_integer4
     module procedure mp_write_array_3d_mpi_integer8
     module procedure mp_write_array_4d_mpi_real4
     module procedure mp_write_array_4d_mpi_real8
     module procedure mp_write_array_4d_mpi_integer4
     module procedure mp_write_array_4d_mpi_integer8
     module procedure mp_write_array_5d_mpi_real4
     module procedure mp_write_array_5d_mpi_real8
     module procedure mp_write_array_5d_mpi_integer4
     module procedure mp_write_array_5d_mpi_integer8
     module procedure mp_write_array_6d_mpi_real4
     module procedure mp_write_array_6d_mpi_real8
     module procedure mp_write_array_6d_mpi_integer4
     module procedure mp_write_array_6d_mpi_integer8
  end interface mp_write_array

contains

  subroutine mp_set_compression(compression)
    implicit none
    logical,intent(in) :: compression
    if(main_process()) call hdf5_set_compression(compression)
  end subroutine mp_set_compression

  integer(hid_t) function mp_open_new(filename, confirm) result(handle)
    implicit none
    character(len=*),intent(in) :: filename
    logical,intent(in),optional :: confirm
    if(main_process()) then
       handle = hdf5_open_new(filename, confirm)
    else
       handle = -12345
    end if
  end function mp_open_new

  integer(hid_t) function mp_open_read(filename) result(handle)
    implicit none
    character(len=*),intent(in) :: filename
    if(main_process()) then
       handle = hdf5_open_read(filename)
    else
       handle = -12345
    end if
  end function mp_open_read

  integer(hid_t) function mp_open_write(filename) result(handle)
    implicit none
    character(len=*),intent(in) :: filename
    if(main_process()) then
       handle = hdf5_open_write(filename)
    else
       handle = -12345
    end if
  end function mp_open_write


  logical function mp_path_exists(handle, path) result(exists)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path
    if(main_process()) exists = hdf5_path_exists(handle, path)
    call mpi_bcast(exists, 1, mpi_logical, rank_main, mpi_comm_world, ierr)
  end function mp_path_exists

  integer(hid_t) function mp_open_group(handle, path) result(group)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path
    if(main_process()) then
       group = hdf5_open_group(handle, path)
    else
       group = -12345
    end if
  end function mp_open_group

  integer(hid_t) function mp_create_group(handle, path) result(group)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path
    if(main_process()) then
       group = hdf5_create_group(handle, path)
    else
       group = -12345
    end if
  end function mp_create_group

  subroutine mp_close_group(group)
    implicit none
    integer(hid_t),intent(in) :: group
    if(main_process()) call hdf5_close_group(group)
  end subroutine mp_close_group

  subroutine mp_list_groups(handle, path, group_names)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path
    character(len=*),allocatable,intent(out) :: group_names(:)
    integer :: n_groups
    if(main_process()) then
       call hdf5_list_groups(handle, path, group_names)
       n_groups = size(group_names)
    end if
    call mpi_bcast(n_groups, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    if(.not.main_process()) allocate(group_names(n_groups))
    call mpi_bcast(group_names, len(group_names(1)) * size(group_names), mpi_character, rank_main, mpi_comm_world, ierr)
  end subroutine mp_list_groups

  subroutine mp_table_write_header(handle,path,n_rows,n_cols,names,widths,types)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path
    integer,intent(in) :: n_cols, n_rows
    character(len=*),intent(in) :: names(:)
    integer,intent(in) :: widths(:)
    integer(hid_t),intent(in) :: types(:)
    if(main_process()) call hdf5_table_write_header(handle,path,n_rows,n_cols,names,widths,types)
  end subroutine mp_table_write_header

  logical function mp_exists_keyword(handle, path, name) result(exists)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path, name
    if(main_process()) exists = hdf5_exists_keyword(handle, path, name)
    call mpi_bcast(exists, 1, mpi_logical, rank_main, mpi_comm_world, ierr)
  end function mp_exists_keyword

  subroutine mp_read_keyword_mpi_character(handle, path, name, value)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path, name
    character(len=*),intent(out) :: value
    if(main_process()) call hdf5_read_keyword(handle, path, name, value)
    call mpi_bcast(value, len(value), mpi_character, rank_main, mpi_comm_world, ierr)
  end subroutine mp_read_keyword_mpi_character

  subroutine mp_write_keyword_mpi_character(handle, path, name, value)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path, name
    character(len=*),intent(in) :: value
    if(main_process()) call hdf5_write_keyword(handle, path, name, value)
  end subroutine mp_write_keyword_mpi_character

  subroutine mp_read_keyword_mpi_logical(handle, path, name, value)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path, name
    logical,intent(out) :: value
    if(main_process()) call hdf5_read_keyword(handle, path, name, value)
    call mpi_bcast(value, 1, mpi_logical, rank_main, mpi_comm_world, ierr)
  end subroutine mp_read_keyword_mpi_logical

  subroutine mp_write_keyword_mpi_logical(handle, path, name, value)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path, name
    logical,intent(in) :: value
    if(main_process()) call hdf5_write_keyword(handle, path, name, value)
  end subroutine mp_write_keyword_mpi_logical

  subroutine mp_table_read_column_auto_1d_mpi_character(handle, path, name, array)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path, name
    character(len=*),allocatable,intent(out) :: array(:)
    integer :: n1
    if(main_process()) call hdf5_table_read_column_auto(handle, path, name, array)
    n1 = size(array)
    call mpi_bcast(n1, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    if(.not. main_process()) allocate(array(n1))
    call mpi_bcast(array, n1, mpi_character, rank_main, mpi_comm_world, ierr)
  end subroutine mp_table_read_column_auto_1d_mpi_character

  subroutine mp_table_write_column_1d_mpi_character(handle, path, name, array)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path, name
    character(len=*),intent(in) :: array(:)
    if(main_process()) call hdf5_table_write_column(handle, path, name, array)
  end subroutine mp_table_write_column_1d_mpi_character

  !!@FOR real(sp):mpi_real4 real(dp):mpi_real8 integer:mpi_integer4 integer(idp):mpi_integer8

  subroutine mp_read_keyword_<T>(handle, path, name, value)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path, name
    @T,intent(out) :: value
    if(main_process()) call hdf5_read_keyword(handle, path, name, value)
    call mpi_bcast(value, 1, <T>, rank_main, mpi_comm_world, ierr)
  end subroutine mp_read_keyword_<T>

  subroutine mp_write_keyword_<T>(handle, path, name, value)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path, name
    @T,intent(in) :: value
    if(main_process()) call hdf5_write_keyword(handle, path, name, value)
  end subroutine mp_write_keyword_<T>

  subroutine mp_table_read_column_auto_1d_<T>(handle, path, name, array)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path, name
    @T,allocatable,intent(out) :: array(:)
    integer :: n1
    if(main_process()) call hdf5_table_read_column_auto(handle, path, name, array)
    n1 = size(array)
    call mpi_bcast(n1, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    if(.not. main_process()) allocate(array(n1))
    call mpi_bcast(array, n1, <T>, rank_main, mpi_comm_world, ierr)
  end subroutine mp_table_read_column_auto_1d_<T>

  subroutine mp_table_read_column_auto_2d_<T>(handle, path, name, array)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path, name
    @T,allocatable,intent(out) :: array(:, :)
    integer :: n1, n2
    if(main_process()) then
       call hdf5_table_read_column_auto(handle, path, name, array)
       n1 = size(array, 1)
       n2 = size(array, 2)
    end if
    call mpi_bcast(n1, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    call mpi_bcast(n2, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    if(.not. main_process()) allocate(array(n1, n2))
    call mpi_bcast(array, n1*n2, <T>, rank_main, mpi_comm_world, ierr)
  end subroutine mp_table_read_column_auto_2d_<T>

  subroutine mp_table_write_column_1d_<T>(handle, path, name, array)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path, name
    @T,intent(in) :: array(:)
    if(main_process()) call hdf5_table_write_column(handle, path, name, array)
  end subroutine mp_table_write_column_1d_<T>

  subroutine mp_table_write_column_2d_<T>(handle, path, name, array)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path, name
    @T,intent(in) :: array(:, :)
    if(main_process()) call hdf5_table_write_column(handle, path, name, array)
  end subroutine mp_table_write_column_2d_<T>

  subroutine mp_read_array_auto_2d_<T>(handle,path,array)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path
    @T,allocatable,intent(out) :: array(:, :)
    integer :: n1, n2
    if(main_process()) then
       call hdf5_read_array_auto(handle,path,array)
       n1 = size(array, 1)
       n2 = size(array, 2)
    end if
    call mpi_bcast(n1, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    call mpi_bcast(n2, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    if(.not. main_process()) allocate(array(n1, n2))
    call mpi_bcast(array, n1*n2, <T>, rank_main, mpi_comm_world, ierr)
  end subroutine mp_read_array_auto_2d_<T>

  subroutine mp_read_array_auto_3d_<T>(handle,path,array)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path
    @T,allocatable,intent(out) :: array(:, :, :)
    integer :: n1, n2, n3
    if(main_process()) then
       call hdf5_read_array_auto(handle,path,array)
       n1 = size(array, 1)
       n2 = size(array, 2)
       n3 = size(array, 3)
    end if
    call mpi_bcast(n1, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    call mpi_bcast(n2, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    call mpi_bcast(n3, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    if(.not. main_process()) allocate(array(n1, n2, n3))
    call mpi_bcast(array, n1*n2*n3, <T>, rank_main, mpi_comm_world, ierr)
  end subroutine mp_read_array_auto_3d_<T>

  subroutine mp_read_array_auto_4d_<T>(handle,path,array)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path
    @T,allocatable,intent(out) :: array(:, :, :, :)
    integer :: n1, n2, n3, n4
    if(main_process()) then
       call hdf5_read_array_auto(handle,path,array)
       n1 = size(array, 1)
       n2 = size(array, 2)
       n3 = size(array, 3)
       n4 = size(array, 4)
    end if
    call mpi_bcast(n1, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    call mpi_bcast(n2, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    call mpi_bcast(n3, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    call mpi_bcast(n4, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    if(.not. main_process()) allocate(array(n1, n2, n3, n4))
    call mpi_bcast(array, n1*n2*n3*n4, <T>, rank_main, mpi_comm_world, ierr)
  end subroutine mp_read_array_auto_4d_<T>

  subroutine mp_read_array_auto_5d_<T>(handle,path,array)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path
    @T,allocatable,intent(out) :: array(:, :, :, :, :)
    integer :: n1, n2, n3, n4, n5
    if(main_process()) then
       call hdf5_read_array_auto(handle,path,array)
       n1 = size(array, 1)
       n2 = size(array, 2)
       n3 = size(array, 3)
       n4 = size(array, 4)
       n5 = size(array, 5)
    end if
    call mpi_bcast(n1, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    call mpi_bcast(n2, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    call mpi_bcast(n3, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    call mpi_bcast(n4, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    call mpi_bcast(n5, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    if(.not. main_process()) allocate(array(n1, n2, n3, n4, n5))
    call mpi_bcast(array, n1*n2*n3*n4*n5, <T>, rank_main, mpi_comm_world, ierr)
  end subroutine mp_read_array_auto_5d_<T>

  subroutine mp_read_array_auto_6d_<T>(handle,path,array)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path
    @T,allocatable,intent(out) :: array(:, :, :, :, :, :)
    integer :: n1, n2, n3, n4, n5, n6
    if(main_process()) then
       call hdf5_read_array_auto(handle,path,array)
       n1 = size(array, 1)
       n2 = size(array, 2)
       n3 = size(array, 3)
       n4 = size(array, 4)
       n5 = size(array, 5)
       n6 = size(array, 6)
    end if
    call mpi_bcast(n1, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    call mpi_bcast(n2, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    call mpi_bcast(n3, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    call mpi_bcast(n4, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    call mpi_bcast(n5, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    call mpi_bcast(n6, 1, mpi_integer4, rank_main, mpi_comm_world, ierr)
    if(.not. main_process()) allocate(array(n1, n2, n3, n4, n5, n6))
    call mpi_bcast(array, n1*n2*n3*n4*n5*n6, <T>, rank_main, mpi_comm_world, ierr)
  end subroutine mp_read_array_auto_6d_<T>

  subroutine mp_write_array_2d_<T>(handle,path,array)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path
    @T,intent(in) :: array(:, :)
    call hdf5_write_array(handle,path,array)
  end subroutine mp_write_array_2d_<T>

  subroutine mp_write_array_3d_<T>(handle,path,array)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path
    @T,intent(in) :: array(:, :, :)
    call hdf5_write_array(handle,path,array)
  end subroutine mp_write_array_3d_<T>

  subroutine mp_write_array_4d_<T>(handle,path,array)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path
    @T,intent(in) :: array(:, :, :, :)
    call hdf5_write_array(handle,path,array)
  end subroutine mp_write_array_4d_<T>

  subroutine mp_write_array_5d_<T>(handle,path,array)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path
    @T,intent(in) :: array(:, :, :, :, :)
    call hdf5_write_array(handle,path,array)
  end subroutine mp_write_array_5d_<T>

  subroutine mp_write_array_6d_<T>(handle,path,array)
    implicit none
    integer(hid_t),intent(in) :: handle
    character(len=*),intent(in) :: path
    @T,intent(in) :: array(:, :, :, :, :, :)
    call hdf5_write_array(handle,path,array)
  end subroutine mp_write_array_6d_<T>

  !!@END FOR

end module mpi_io
