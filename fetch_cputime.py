import os
import re

def find_log_files(root_dir):
    """查找所有以.log为后缀的文件"""
    log_files = []
    for root, _, files in os.walk(root_dir):
        for file in files:
            if file.endswith('.log'):
                log_files.append(os.path.join(root, file))
    return log_files

def extract_cpu_usage(file_path):
    """从文件中提取CPU usage for this session: 后的数据"""
    pattern = re.compile(r'CPU usage for this session:\s*(\S+)')
    
    with open(file_path, 'r') as f:
        for line in f:
            match = pattern.search(line)
            if match:
                return match.group(1)
    
    return None  # 如果没有找到匹配项，返回None

def process_files(input_dir, output_file):
    """处理所有文件并输出结果"""
    log_files = find_log_files(input_dir)
    
    with open(output_file, 'w') as out_f:
        # 写入表头
        out_f.write("File Path,CPU Usage\n")
        
        for file_path in log_files:
            cpu_usage = extract_cpu_usage(file_path)
            
            # 准备输出行
            output_line = [file_path]  # 文件路径作为第一列
            
            if cpu_usage is not None:
                output_line.append(cpu_usage)
                # 写入输出文件
                out_f.write(",".join(output_line) + "\n")

if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description='Extract CPU usage from .log files')
    parser.add_argument('input_dir', help='Directory to search for .log files')
    parser.add_argument('output_file', help='Output CSV file path')
    
    args = parser.parse_args()
    
    process_files(args.input_dir, args.output_file)
    print(f"Processing complete. Results saved to {args.output_file}")
