
import click
import pandas as pd
from io import StringIO
import subprocess
import hashlib


def capture_qstat_now(salt_value):
    """Create dataframe from qstatall, minus sensitive info, plus timestamp."""

    # get timestamp before the (possibly slow) parsing happens
    time_stamp = pd.Timestamp.now()

    # call qstat and capture stdout stream
    qstat_cmd = ['qstatall', ]
    qstat_stdout = subprocess.Popen(qstat_cmd, stdout=subprocess.PIPE)
    qstat_file_like = StringIO(qstat_stdout.communicate()[0].decode('utf-8'))

    # read into pd dataframe, drop sensitive info, and remove separator row
    df = pd.read_csv(qstat_file_like, delim_whitespace=True)
    df["Identifier"] = [hashlib.sha256(str(reqid+salt_value).encode('utf-8')).hexdigest()[:16] for reqid in df["RequestID"]]
    df = df.drop(columns=["RequestID", "ReqName", "UserName"])
    df = df.drop(df.index[0])

    # set time stamp
    df['time'] = time_stamp

    return df


@click.command()
@click.argument("salt_value")
@click.argument("file_name")
def write_df_to_disk(salt_value,file_name):
    """Dump qstatall dataframe to `file_name`."""
    df = capture_qstat_now(salt_value)
    df.to_csv(file_name)


if __name__ == '__main__':
    write_df_to_disk()
