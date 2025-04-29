#!/usr/bin/env python3

import sys
import os

class PageTable:
    def __init__(self, n_bits, m_bits, page_size):
        self.n_bits = n_bits  # Number of bits in virtual address
        self.m_bits = m_bits  # Number of bits in physical address
        self.page_size = page_size  # Size of a page in bytes
        
        # Calculate number of entries in page table
        self.num_pages = 2 ** (n_bits - self.calc_offset_bits())
        
        # Initialize page table entries
        self.entries = []
        
        # For Part B: Clock algorithm
        self.clock_pointer = 0
        
    def calc_offset_bits(self):
        # Calculate number of bits needed for page offset
        return self.bits_needed(self.page_size)
    
    @staticmethod
    def bits_needed(value):
        # Calculate number of bits needed to represent a value
        bits = 0
        while value > 1:
            value //= 2
            bits += 1
        return bits
    
    def load_page_table(self, filename):
        """Load page table from file"""
        try:
            with open(filename, 'r') as f:
                lines = [line.strip() for line in f.readlines() if line.strip()]
                
                # Parse first line: N M SIZE
                parts = lines[0].split()
                if len(parts) != 3:
                    raise ValueError("First line must contain N M SIZE")
                
                self.n_bits = int(parts[0])
                self.m_bits = int(parts[1])
                self.page_size = int(parts[2])
                
                # Calculate expected number of pages
                self.num_pages = 2 ** (self.n_bits - self.calc_offset_bits())
                
                # Parse page table entries
                for i in range(1, len(lines)):
                    parts = lines[i].split()
                    if len(parts) != 4:
                        continue  # Skip malformed lines
                    
                    valid = int(parts[0])
                    permission = int(parts[1])
                    frame = int(parts[2])
                    used = int(parts[3])
                    
                    self.entries.append({
                        'valid': valid,
                        'permission': permission,
                        'frame': frame,
                        'used': used
                    })
                
                # Validate entries count
                if len(self.entries) != self.num_pages:
                    print(f"Warning: Expected {self.num_pages} entries, but found {len(self.entries)}.")
                
                # Initialize clock pointer to first valid page
                for i, entry in enumerate(self.entries):
                    if entry['valid'] == 1:
                        self.clock_pointer = i
                        break
                
        except Exception as e:
            print(f"Error loading page table: {e}")
            sys.exit(1)
    
    def translate_address(self, virtual_addr, use_clock=False):
        """Translate virtual address to physical address"""
        # Calculate offset bits
        offset_bits = self.calc_offset_bits()
        
        # Extract page number and offset
        page_mask = (1 << (self.n_bits - offset_bits)) - 1
        offset_mask = (1 << offset_bits) - 1
        
        page_num = (virtual_addr >> offset_bits) & page_mask
        offset = virtual_addr & offset_mask
        
        # Check if page number is valid
        if page_num >= len(self.entries):
            return "SEGFAULT"
        
        entry = self.entries[page_num]
        
        # Check permissions and validity
        if not entry['valid']:
            if entry['permission'] == 0:
                return "SEGFAULT"
            elif use_clock:
                # Part B: Handle page fault with Clock algorithm
                evicted_page, frame = self.handle_page_fault(page_num)
                physical_addr = (frame << offset_bits) | offset
                return f"PAGEFAULT {hex(evicted_page)}" if "--hex" in sys.argv else f"PAGEFAULT {evicted_page}", physical_addr
            else:
                # Part A: Just report disk access
                return "DISK"
        
        # Mark the page as used (for Clock algorithm)
        entry['used'] = 1
        
        # Calculate physical address
        physical_addr = (entry['frame'] << offset_bits) | offset
        return physical_addr
    
    def handle_page_fault(self, page_num):
        """Handle page fault using Clock algorithm"""
        # Find a page to evict using the Clock algorithm
        evicted_page = None
        start_pointer = self.clock_pointer  # Remember starting position
        
        # First pass - try to find a page with used=0
        while True:
            # Check if current page is valid
            current_entry = self.entries[self.clock_pointer]
            
            if current_entry['valid'] == 1:
                if current_entry['used'] == 0:
                    # Found a page to evict
                    evicted_page = self.clock_pointer
                    break
                else:
                    # Give second chance
                    current_entry['used'] = 0
            
            # Move clock pointer
            self.clock_pointer = (self.clock_pointer + 1) % len(self.entries)
            
            # If we've made a full circle and still haven't found a page to evict
            if self.clock_pointer == start_pointer:
                # Take first valid page on second pass (which now has used=0)
                while True:
                    if self.entries[self.clock_pointer]['valid'] == 1:
                        evicted_page = self.clock_pointer
                        break
                    self.clock_pointer = (self.clock_pointer + 1) % len(self.entries)
                break
        
        # Evict the page and load the new one
        evicted_entry = self.entries[evicted_page]
        target_entry = self.entries[page_num]
        
        # Get frame number from evicted page
        frame = evicted_entry['frame']
        
        # Update entries
        evicted_entry['valid'] = 0
        target_entry['valid'] = 1
        target_entry['frame'] = frame
        target_entry['used'] = 1
        
        # Move clock pointer
        self.clock_pointer = (self.clock_pointer + 1) % len(self.entries)
        
        return evicted_page, frame

def is_hex(s):
    """Check if input string is a hex number"""
    return s.lower().startswith('0x')

def parse_address(addr_str):
    """Parse address input as decimal or hex"""
    if is_hex(addr_str):
        return int(addr_str, 16)
    else:
        return int(addr_str)

def format_output(value, use_hex=False):
    """Format output as decimal or hex"""
    if isinstance(value, int):
        if use_hex:
            return f"0x{value:x}"
        else:
            return str(value)
    return value

def main():
    # Parse command line arguments
    if len(sys.argv) < 2:
        print("Usage: python pt_sim.py <page_table_file> [--clock] [--hex]")
        sys.exit(1)
    
    page_table_file = sys.argv[1]
    use_clock = "--clock" in sys.argv
    use_hex = "--hex" in sys.argv
    
    # Create page table
    page_table = PageTable(0, 0, 0)
    page_table.load_page_table(page_table_file)
    
    # Print welcome message
    if use_clock:
        print("Welcome to PT-Sim-Clock, the enhanced page table simulator")
    else:
        print("Welcome to PT-Sim, the page table simulator")
    print(f"Using input file {page_table_file}")
    
    # Process input addresses
    try:
        while True:
            line = input().strip()
            if not line:
                continue
            
            try:
                virtual_addr = parse_address(line)
                result = page_table.translate_address(virtual_addr, use_clock)
                
                if isinstance(result, tuple):
                    pagefault_msg, physical_addr = result
                    print(pagefault_msg)
                    print(format_output(physical_addr, use_hex))
                else:
                    print(format_output(result, use_hex))
            except ValueError as e:
                print(f"Error: {e}")
    except EOFError:
        pass

if __name__ == "__main__":
    main()