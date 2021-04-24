
import os
import strings

#include <Windows.h>
#include <processenv.h>
#include <psapi.h>

#flag -lpsapi // link to psapi.lib

// WIN32 API Function definitions
fn C.MessageBoxW(voidptr, &u16, &u16, u64) int
fn C.GetComputerNameW(&u16, &u32) bool
fn C.GetCommandLineW() &u16
fn C.EnumProcesses(&u32, u32, &u32) bool
fn C.GetVersionExW(&OSVERSIONINFO) bool

// https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-rprn/5942648e-b54f-4e22-a0e2-2d000e084b23
struct OSVERSIONINFO {
mut:
	dw_os_version_info_size u32
	dw_major_version u32
	dw_minor_version u32
	dw_build_number u32
	dw_platform_id u32
	sz_csd_version [256]char
}

pub fn message_box(message string) {
	m := message.to_wide()
	C.MessageBoxW(0, m, m, 0)
}

pub fn hostname() string {
	hostname := [255]u16
	size := u32(255)
	res := C.GetComputerNameW(&hostname[0], &size)
	if !res {
		return error(get_error_msg(int(C.GetLastError())))
	}
	return string_from_wide(&hostname[0])
}

pub fn get_commandline() string {
	cmdline := C.GetCommandLineW()
	return string_from_wide(cmdline)
}

pub fn get_pids() ?[]u32 {
	mut pids := []u32
	aprocesses := [1024]u32
	cbneeded := u32(0)
	result := C.EnumProcesses(&aprocesses[0], sizeof(aprocesses), &cbneeded)
	if !result {
		return error(get_error_msg(int(C.GetLastError())))
	}
	for pid in aprocesses {
		if pid != 0 {
			pids << pid
		}
	}
	return pids
}

pub fn get_version() string {
	mut info := OSVERSIONINFO{}
	info.dw_os_version_info_size = sizeof(info)
	result := C.GetVersionExW(&info)
	return "Version: $info.dw_major_version, $info.dw_minor_version, $info.dw_build_number"
}

fn main() {
	//message_box("Hello World")
	println(hostname())
	println(get_commandline())
	println(get_version())
	pids := get_pids() or { []u32 }
	println(pids.len)
}